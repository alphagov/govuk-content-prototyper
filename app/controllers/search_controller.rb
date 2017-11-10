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

    add_fake_results(document)

    document.to_html
  end

  def add_fake_results(document)
    first_element = document.css('.results-list li').first
    first_element.add_previous_sibling(
      %q{
        <li>
          <h3>
            <a href="/services/get-a-divorce">
              Get a divorce: step by step
            </a>
          </h3>
          <p>How to file for divorce if you’re in England or Wales.</p>
        </li>
        <li>
          <h3>
            <a href="/services/end-a-civil-partnership">
              End a civil partnership: step by step
            </a>
          </h3>
          <p>How to end your civil partnership if you’re in England or Wales.</p>
        </li>
      }
    )
  end

  def bypass_slimmer
    response.headers[Slimmer::Headers::SKIP_HEADER] = 'true'
  end
end
