class ServicesController < ApplicationController
  layout 'collections'

  def show
    render "accordion", locals: {
      navigation: navigation,
      content_item: content_item
    }
  end

  def index
  end

  def divorce
  end

  def civilpartnership
  end

  def childarrangements
  end

private

  def service
    @service ||= SchemaFinderService.new(base_path: params[:base_path])
  end

  def content_item
    @content_item ||= service.content_item
  end

  def navigation
    @navigation ||= GovukNavigationHelpers::NavigationHelper.new(content_item)
  end
end
