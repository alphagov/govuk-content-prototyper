class ApplicationController < ActionController::Base
  before_filter :authenticate

  include Slimmer::GovukComponents

  protect_from_forgery with: :exception

  private

  def authenticate
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['USERNAME'] && password == ENV['PASSWORD']
    end
  end

  def setup_content_item_and_navigation_helpers(model)
    @content_item = model.content_item.to_hash
    @navigation_helpers =
      GovukNavigationHelpers::NavigationHelper.new(@content_item)
  end
end
