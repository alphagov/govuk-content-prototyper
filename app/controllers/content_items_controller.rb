require 'open-uri'

class ContentItemsController < ApplicationController
  def show
    render :show, locals: {
      content_html: content_html,
      stylesheet_links_html: stylesheet_links_html,
      main_attributes: main_attributes,
      breadcrumbs: navigation_helpers.taxon_breadcrumbs[:breadcrumbs],
      taxonomy_sidebar: navigation_helpers.taxonomy_sidebar,
    }
  end

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
    @full_content_item_html ||= Nokogiri::HTML(
      open("https://www.gov.uk/#{params[:base_path]}",
        # Ensure we get the new version of the page, which should have all content in a two-thirds column
        'Cookie' => 'ABTest-EducationNavigation=B',
      ).read
    )
  end

  def navigation_helpers
    @navigation_helpers ||= GovukNavigationHelpers::NavigationHelper.new(content_item)
  end

  def content_item
    @content_item ||= Services.content_store.content_item("/#{params[:base_path]}")
  end
end
