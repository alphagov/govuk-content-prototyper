require 'open-uri'

class ContentItemsController < ApplicationController
  rescue_from OpenURI::HTTPError, with: :handle_http_error

  def show
    render :show, locals: {
      content_html: content_html,
      stylesheet_links_html: stylesheet_links_html,
      main_attributes: main_attributes,
      breadcrumbs: breadcrumbs,
      taxonomy_sidebar: navigation_helpers.taxonomy_sidebar,
      page_type: page_type,
    }
  end

  # This method is used to display any pages the prototype is not concerned with. It does this by fetching the page
  # from the production site and rendering the response verbatim as HTML.
  # NB: Any **NON-HTML** requests will **STILL BE RETURNED AS HTML**. An example of this is the Miller Columns for
  # the browse pages, which rely on a JSON object being returned (but is currently broken, because the JSON is returned
  # as text/html, not as JSON)
  def fall_through
    bypass_slimmer
    render html: raw_content_item_html.html_safe
  end

private

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
      raw_html = open("https://#{ENV['GOVUK_APP_DOMAIN']}#{request.fullpath}?cachebust=#{Time.zone.now.to_i}",
        # Ensure we get the new version of the page, which should have all content in a two-thirds column
        'Cookie' => 'ABTest-EducationNavigation=B',
      ).read

      request.path == '/' ? edit_home_page_html(raw_html) : raw_html
    end
  end

  def edit_home_page_html(html)
    document = Nokogiri::HTML(html)
    document.at_css('.header-logo a')['href'] = '/'
    update_childcare_and_parenting_on_home_page(document)
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
end
