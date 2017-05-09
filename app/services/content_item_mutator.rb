module Services
  class ContentItemMutator
    def self.mutate_content_item(content_item)
      mapping = mapping_for(content_item['base_path'])
      return content_item if mapping.nil?
      content_item.to_hash.merge(mapping)
    end

    def self.mapping_for(base_path)
      Config.content_mappings[base_path] || {}
    end
  end
end
