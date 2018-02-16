class ApplicationController < ActionController::Base
  before_action :authenticate

  include Slimmer::GovukComponents

  protect_from_forgery with: :exception

  private

  def authenticate
    return unless Rails.env.production?

    # authenticate_or_request_with_http_basic do |username, password|
    #   username == ENV['USERNAME'] && password == ENV['PASSWORD']
    # end
  end

  def setup_content_item_and_navigation_helpers(model)
    @content_item = model.content_item.to_hash
    @navigation_helpers =
      GovukNavigationHelpers::NavigationHelper.new(@content_item)
  end

  def breadcrumb_content
    render_partial(
      '_breadcrumbs',
      navigation_helpers: @navigation_helpers
    )
  end

  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: 'html', layout: false, locals: locals)
  end
end
