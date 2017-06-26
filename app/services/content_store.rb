require 'gds_api/content_store'
require 'content_item_mutator'

module Services
  def self.content_store
    @content_store ||= ContentStore.new
  end

  class ContentStore
    def content_item(base_path)
      content_store_response = local_taxons_by_base_path[base_path] || content_store.content_item(base_path)
      add_local_taxons!(content_store_response)
      ContentItemMutator.mutate_content_item(content_store_response)
    end

    private

    def local_taxons_by_base_path
      @local_taxons_by_base_path ||= Config.taxons.each_with_object({}) do |taxon, hash|
        hash[taxon['base_path']] = taxon
      end
    end

    def local_taxons_by_content_id
      @local_taxons_by_content_id ||= Config.taxons.each_with_object({}) do |taxon, hash|
        hash[taxon['content_id']] = taxon
      end
    end

    def add_local_taxons!(content_item)
      search_result = Services.rummager.search(
        start: 0,
        count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
        filter_link: content_item['base_path'],
        fields: %w[taxons],
      ).to_h['results'][0] || {}

      taxon_ids = search_result['taxons'] || []
      content_item['links']['taxons'] ||= [] if taxon_ids.any?
      taxon_ids
        .map { |taxon_id| local_taxons_by_content_id[taxon_id] }
        .each { |taxon| content_item['links']['taxons'] << taxon if taxon }
    end

    def content_store
      @content_store ||=
        GdsApi::ContentStore.new(Plek.new.find('content-store'), verify_ssl: false)
    end
  end
end
