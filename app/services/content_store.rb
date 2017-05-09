require 'gds_api/content_store'
require 'content_item_mutator'

module Services
  def self.content_store
    @content_store ||= ContentStore.new
  end

  class ContentStore
    def content_item(base_path)
      content_store_response = content_store.content_item(base_path)
      ContentItemMutator.mutate_content_item(content_store_response)
    end

    private

    def content_store
      @content_store ||=
        GdsApi::ContentStore.new(Plek.new.find('content-store'))
    end
  end
end
