class ServicesController < ApplicationController
  layout 'collections'

  def show
    page_template = page_schema.rendering_type

    render page_template, locals: {
      page_schema: page_schema
    }
  end

private
  def page_schema
    @page_schema ||= SchemaFinderService.find(params[:base_path])
  end
end
