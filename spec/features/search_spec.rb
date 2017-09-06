require 'rails_helper'

RSpec.feature 'The search page' do
  let(:search_results_html) { File.read(fixture_file('govuk_search_results.html')) }

  it "should insert the learn to drive item as the first result" do
    allow_any_instance_of(SearchController).to receive(:get_content).and_return search_results_html

    visit '/search?q=test'
    first_result_title = page.first("h3").text

    expect(first_result_title).to eq("Learn to drive a car: step by step")
    expect(page).to have_selector('h3', count: 4)
  end

  def fixture_file(file)
    File.expand_path("fixtures/" + file, File.dirname(__FILE__))
  end
end
