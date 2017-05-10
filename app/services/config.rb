class Config
  def self.guidance_document_collections
    @guidance_document_collections ||= JSON.parse(
      load_config('guidance_document_collections.json')
    )
  end

  def self.content_mappings
    @content_item_mappings ||= YAML.load(
      load_config('content_mappings.json')
    )
  end

  def self.search_overrides
    @search_overrides ||= JSON.parse(
      load_config('search_overrides.json')
    )
  end

  def self.high_volume_content
    @high_volume_content ||= JSON.parse(
      load_config('high_volume_content.json')
    )
  end

  def self.load_config(filename)
    File.read(
      Rails.root.join(
        'config',
        filename
      )
    )
  end
end
