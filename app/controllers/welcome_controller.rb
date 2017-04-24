class WelcomeController < ApplicationController
  def index
    render :index, locals: { examples: examples }
  end

  private

  def examples
    options =
      search_response.dig('facets', 'content_store_document_type', 'options')

    options = options.map { |option| ExampleResult.new(option) }
    options.sort_by(&:document_type)
  end

  def search_response
    Services.rummager.search(
      filter_navigation_document_supertype: 'guidance',
      facet_content_store_document_type: '500,examples:1,example_scope:global'
    )
  end
end
