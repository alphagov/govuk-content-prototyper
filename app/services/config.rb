class Config
  def self.guidance_document_collections
    @guidance_document_collections ||= JSON.parse(
      load_config('guidance_document_collections.json')
    )
  end

  def self.search_overrides
    @search_overrides ||= JSON.parse(
      load_config('search_overrides.json')
    )
  end

  def self.taxons
    @taxons ||= JSON.parse(
      load_config('taxons.json')
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
