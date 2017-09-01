require 'open-uri'

module ContentRequester
  extend ActiveSupport::Concern

  included do
    rescue_from OpenURI::HTTPError, with: :handle_http_error
  end

  def raw_content_item_html(cookie: "ABTest-EducationNavigation=B")
    @raw_html ||= begin
      uri =  URI.parse("https://#{ENV['GOVUK_APP_DOMAIN']}#{request.fullpath}")
      query_params = URI.decode_www_form(String(uri.query)) << ["cachebust", Time.zone.now.to_i]
      uri.query = URI.encode_www_form(query_params)
      raw_html = open(uri.to_s, "Cookie" => cookie).read
    end
  end
end
