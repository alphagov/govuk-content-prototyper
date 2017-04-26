require 'open-uri'

class ContentItemsController < ApplicationController
  rescue_from OpenURI::HTTPError, with: :handle_http_error

  def show
    render :show, locals: {
      content_html: content_html,
      stylesheet_links_html: stylesheet_links_html,
      main_attributes: main_attributes,
      breadcrumbs: navigation_helpers.taxon_breadcrumbs[:breadcrumbs],
      taxonomy_sidebar: navigation_helpers.taxonomy_sidebar,
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

  def content_html
    # Different rendering apps structure the sidebar differently - try to get the actual content without the sidebar.
    # Note that this approach may break for content not styled properly for the Navigation Beta
    content_html = main_html.css('.column-two-thirds').first || main_html
    content_html.inner_html.html_safe
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
    @main_html ||= full_content_item_html.css('main').first
  end

  def full_content_item_html
    @full_content_item_html ||= Nokogiri::HTML(raw_content_item_html)
  end

  def raw_content_item_html
    @raw_html ||= open("https://www.gov.uk#{request.fullpath}",
      # Ensure we get the new version of the page, which should have all content in a two-thirds column
      'Cookie' => 'ABTest-EducationNavigation=B',
    ).read
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
end
