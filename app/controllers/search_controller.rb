require 'open-uri'

class SearchController < ApplicationController
  def results
    bypass_slimmer

    raw_html = raw_content_item_html
    render html: edit_results_page_html(raw_html).html_safe
  end

private

  def get_content(uri)
    open(uri.to_s, 'Cookie' => "ABTest-EducationNavigation=B").read
  end

  def raw_content_item_html
    @raw_html ||= begin
      uri =  URI.parse("https://#{ENV['GOVUK_APP_DOMAIN']}#{request.fullpath}")
      query_params = URI.decode_www_form(String(uri.query)) << ["cachebust", Time.zone.now.to_i]
      uri.query = URI.encode_www_form(query_params)
      raw_html = get_content(uri)
    end
  end

  def edit_results_page_html(html)
    document = Nokogiri::HTML(html)
    document.css('.results-list li').first.add_previous_sibling('<li><h3><a href="/services/learn-to-drive-a-car">Learn to drive a car: step by step</a></h3><p>Check what you need to do to learn to drive.</p></li>')

    document.to_html
  end

  def bypass_slimmer
    response.headers[Slimmer::Headers::SKIP_HEADER] = 'true'
  end
end
