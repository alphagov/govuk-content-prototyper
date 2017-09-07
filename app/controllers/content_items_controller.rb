require 'open-uri'

class ContentItemsController < ApplicationController
  rescue_from OpenURI::HTTPError, with: :handle_http_error

  CONTENT_TYPES = {
    "pdf" => :pdf,
    "doc" => "application/msword",
    "png" => :png
  }

  def show
    @page_schema = schema_finder.page_schema
    step_and_task_numbers = task_navigation_service.task_number_for_page

    @cookie_name = "ABTest-EducationNavigation=B"
    render :show, locals: {
      content_html: content_html,
      stylesheet_links_html: stylesheet_links_html,
      main_attributes: main_attributes,
      breadcrumbs: breadcrumbs,
      task_sidebar: task_sidebar,
      taxonomy_sidebar: navigation_helpers.taxonomy_sidebar,
      page_type: page_type,
      current_step_title: schema_finder.find_base_path_title(params[:base_path]),
      current_step_number: step_and_task_numbers[0],
      current_task_number: step_and_task_numbers[1],
      override_sidebar: task_navigation_service.applicable_content?
    }
  end

  def showforms
    @page_schema = schema_finder.page_schema
    step_and_task_numbers = task_navigation_service.task_number_for_page

    @cookie_name = "ABTest-EducationNavigation=A"
    render :show, locals: {
      content_html: main_html.inner_html.html_safe,
      stylesheet_links_html: stylesheet_links_html,
      main_attributes: main_attributes,
      breadcrumbs: breadcrumbs,
      task_sidebar: task_sidebar,
      taxonomy_sidebar: navigation_helpers.taxonomy_sidebar,
      page_type: page_type,
      current_step_title: schema_finder.find_base_path_title(params[:base_path]),
      current_step_number: step_and_task_numbers[0],
      current_task_number: step_and_task_numbers[1],
      override_sidebar: task_navigation_service.applicable_content?
    }
  end

  def browse
    @cookie_name = "ABTest-EducationNavigation=B"
    bypass_slimmer

    raw_html = raw_content_item_html
    render html: edit_browse_page_html(raw_html).html_safe
  end

  # This method is used to display any pages the prototype is not concerned with. It does this by fetching the page
  # from the production site and rendering the response verbatim as HTML.
  # NB: Any **NON-HTML** requests will **STILL BE RETURNED AS HTML**. An example of this is the Miller Columns for
  # the browse pages, which rely on a JSON object being returned (but is currently broken, because the JSON is returned
  # as text/html, not as JSON)
  def fall_through
    @cookie_name = "ABTest-EducationNavigation=B"
    bypass_slimmer

    if CONTENT_TYPES.keys.include? params["format"]
      file = open("https://#{ENV['GOVUK_APP_DOMAIN']}#{request.fullpath}").read
      send_data file, type: CONTENT_TYPES[params["format"]], disposition: :inline
    else
      render html: raw_content_item_html.html_safe
    end
  end

private

  def task_sidebar
    return {} unless task_nav

    {
      "title" => task_nav["title"],
      "base_path" => task_nav["base_path"],
      "ordered_steps" => task_nav["links"],
    }
  end

  def breadcrumbs
    if SchemaFinderService.taxonomy_supported?(params[:base_path])
      navigation_helpers.taxon_breadcrumbs[:breadcrumbs]
    else
      navigation_helpers.breadcrumbs[:breadcrumbs]
    end
  end

  def content_html
    # Different rendering apps structure the sidebar differently - try to get the actual content without the sidebar.
    # Note that this approach may break for content not styled properly for the Navigation Beta
    content_html = if guidance_page?
      main_html.css('.column-two-thirds') || main_html
    else
      main_html.css('.column-two-thirds').first || main_html
    end

    content_html.inner_html.html_safe
  end

  def guidance_page?
    main_html.css('.govuk-title').children.any? do |child|
      child.text == "Guidance"
    end
  end

  def stylesheet_links_html
    html = full_content_item_html
    # Ensure we load all the styles required by the content item. This approach may double-load some CSS,
    # but the overhead should be unimportant (especially with caching)
    html.css('link[rel="stylesheet"]')
      .map(&:to_html)
      .join
      .html_safe
  end

  def main_attributes
    main_html.attributes.reduce('') do |attributes, (key, value)|
      attributes + "#{key}=#{value} "
    end
  end

  def main_html
    full_content_item_html.css('h2#history').remove_attr('id')
    @main_html ||= full_content_item_html.css('main').first
  end

  def full_content_item_html
    @full_content_item_html ||= Nokogiri::HTML(raw_content_item_html)
  end

  def raw_content_item_html
    @raw_html ||= begin
      uri =  URI.parse("https://#{ENV['GOVUK_APP_DOMAIN']}#{request.fullpath}")
      query_params = URI.decode_www_form(String(uri.query)) << ["cachebust", Time.zone.now.to_i]
      uri.query = URI.encode_www_form(query_params)
      open(uri.to_s, 'Cookie' => @cookie_name).read
    end
  end

  def edit_home_page_html(html)
    document = Nokogiri::HTML(html)
    document.at_css('.header-logo a')['href'] = '/'
    update_childcare_and_parenting_on_home_page(document)
    document.to_html
  end

  def edit_browse_page_html(html)
    document = Nokogiri::HTML(html)
    document.css('.high-volume ol li').last.replace('<li><a href="/services/how-to-become-a-childminder">How to become a childminder</a></li>')

    how_to_object_link = document.at_css('[href="/government/publications/how-to-object-guidance-for-registered-childminders-and-childcare-providers"]')

    if how_to_object_link
      how_to_object_li = how_to_object_link.ancestors('li').first

      how_to_object_li.add_previous_sibling('<li class="subsection-list-item"><a href="/services/how-to-become-a-childminder">How to become a childminder</a><p>You need to follow this process if you\'re registering as a childminder with Ofsted. You don\'t need to do this if you\'re registering with an agency. The process is different if you\'re in Wales, Scotland or Northern Ireland.</p></li>')
    end

    document.to_html
  end

  def update_childcare_and_parenting_on_home_page(document)
    taxon = childcare_parenting_taxon

    childcare_parenting_link = document.at_css('[href="/browse/childcare-parenting"]')
    childcare_parenting_li = childcare_parenting_link.ancestors('li').first
    childcare_parenting_description = childcare_parenting_li.at_css('p')

    childcare_parenting_link['href'] = taxon['base_path']
    childcare_parenting_link.content = taxon['title']
    childcare_parenting_description.content = taxon['description']

    tax_li = document
      .at_css('[href="/browse/tax"]')
      .ancestors('li')
      .first

    tax_li.add_next_sibling(childcare_parenting_li)
  end

  def childcare_parenting_taxon
    @childcare_parenting_taxon ||= Config.taxons
      .first { |taxon| taxon['base_path'] == '/childcare-parenting' }
  end

  def navigation_helpers
    @navigation_helpers ||= GovukNavigationHelpers::NavigationHelper.new(content_item)
  end

  def content_item
    request.env['content_item']
  end

  def bypass_slimmer
    response.headers[Slimmer::Headers::SKIP_HEADER] = 'true'
  end

  def handle_http_error(error)
    puts "Error fetching #{request.path}: #{error}"
    render plain: error
  end

  def page_type
    wrapper_class = full_content_item_html.css('#wrapper').attr('class')
    wrapper_class && wrapper_class.value || 'guidance'
  end

  def schema_finder
    @schema_finder ||= SchemaFinderService.new(base_path: '/learn-to-drive-a-car')
  end

  def task_nav
    @task_nav ||= content_item["links"]["ordered_tasks"]
  end

  def task_navigation_service
    TaskNavigationService.new(
      schema_name: schema_finder.name,
      base_path: request.env['content_item'].dig('base_path') || params[:base_path]
    )
  end
end
