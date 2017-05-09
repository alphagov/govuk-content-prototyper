class Config
  def self.guidance_document_collections
    @guidance_document_collections ||= JSON.parse(
      load_config('guidance_document_collections.json')
    )
  end

  def self.content_mappings
    @content_item_mappings ||= YAML.load(
      load_config('content_mappings.yaml')
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
