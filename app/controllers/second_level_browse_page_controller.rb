class SecondLevelBrowsePageController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: render_partial('_links', page: page)
        }
      end
    end
  end

private

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page
    MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}")
  end
end
