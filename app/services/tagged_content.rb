class TaggedContent
  attr_reader :content_id, :base_path

  def initialize(content_id:, base_path:)
    @content_id = content_id
    @base_path = base_path
  end

  def self.fetch(content_id:, base_path:)
    new(content_id: content_id, base_path: base_path).fetch
  end

  def fetch
    search_response
      .documents
      .select { |document| tagged_content_validator.valid?(document) }
      .select { |document| hide_from_search_validator.valid?(document) }
  end

private

  def tagged_content_validator
    @tagged_content_validator ||= TaggedContentValidator.new
  end

  def hide_from_search_validator
    @hide_from_search_validator ||= HideFromSearchValidator.new(base_path)
  end

  def search_response
    RummagerSearch.new(
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link document_collections content_store_document_type),
      filter_navigation_document_supertype: 'guidance',
      filter_taxons: [content_id],
      order: 'title',
    )
  end
end
