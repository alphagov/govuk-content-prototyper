class ServicesController < ApplicationController
  layout 'collections'

  def show
    page_template = page_schema.rendering_type

    render page_template, locals: {
      page_schema: page_schema,
      navigation: navigation
    }
  end

private

  def service
    SchemaFinderService.new(base_path: params[:base_path])
  end

  def page_schema
    @page_schema ||= service.page_schema
  end

  def navigation
    @navigation ||= GovukNavigationHelpers::NavigationHelper.new(service.content_item)
  end
end
