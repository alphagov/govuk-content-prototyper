class ContentItemMutator
  CHILDCARE_URLS = ['/guidance/how-to-register-as-a-childminder-or-nanny-quick-guide',
    '/legal-right-work-uk',
    '/government/publications/become-a-registered-early-years-or-childcare-provider-in-england',
    '/government/publications/applying-to-waive-disqualification-early-years-and-childcare-providers'
  ].freeze

  def self.mutate_content_item(content_item)
    return content_item if empty_content_store_response?(content_item)
    base_path = content_item['base_path']
    mapping = mapping_for(base_path)
    mutated_content_item = content_item.to_hash.merge(mapping)

    if TaskNavigationService.new(base_path: base_path).task_navigation_supported?
      mutated_content_item.merge(task_nav(base_path))
    end
  end

  def self.empty_content_store_response?(content_item)
    content_item.respond_to?(:raw_response_body) && content_item.raw_response_body.empty?
  end

  def self.mapping_for(base_path)
    Config.content_mappings[base_path] || {}
  end

  def self.task_nav(base_path)
    TaskNavigationService.new(base_path: base_path).navigation_config
  end

  def self.task_navigation_service(base_path)
  end
end
