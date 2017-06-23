class ApplicationController < ActionController::Base
  before_filter :authenticate

  include Slimmer::GovukComponents

  protect_from_forgery with: :exception

  def education_ab_test
    @education_ab_test ||= begin
      ab_test_request = EducationNavigationAbTestRequest.new(request)
      ab_test_request.set_response_vary_header(response)
      ab_test_request
    end
  end


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
