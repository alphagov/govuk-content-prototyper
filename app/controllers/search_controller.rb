class SearchController < ApplicationController
  include SlimmerSkipper
  include ContentRequester

  def results
    bypass_slimmer

    raw_html = raw_content_item_html
    render html: edit_results_page_html(raw_html).html_safe
  end

private

  def edit_results_page_html(html)
    document = Nokogiri::HTML(html)
    document.css('.results-list li').first.add_previous_sibling('<li><h3><a href="/services/how-to-drive-a-car">How to drive a car</a></h3><p>Find out what you need to do to drive a car in the UK.</p></li>')

    document.to_html
  end
end
