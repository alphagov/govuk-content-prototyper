class ServicesController < ApplicationController
  layout 'collections'

  def show
    page_schema = ServicePageFinder.find(params[:base_path])
    page_template = page_schema.rendering_type || :accordion

    render page_template, locals: { page_schema: page_schema }
  end
end
