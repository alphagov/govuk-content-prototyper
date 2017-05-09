require 'set'

module Services
  class SearchMutator
    def self.mutate_search(search)
      mutated_search = search.to_hash
      mutated_search['results'].select! { |content_item| should_display?(content_item) }
      mutated_search
    end

    def self.should_display?(content_item)
      base_path = content_item['link']
      !paths_to_hide.include?(base_path)
    end

    def self.paths_to_hide
      @paths_to_hide ||= Config.content_mappings['hide_from_search'].to_set
    end
  end
end
