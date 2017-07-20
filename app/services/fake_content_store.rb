class FakeContentStore
  def initialize(base_path:, theme: 'childminder')
    @base_path = base_path
    @theme = theme
  end

  def has_local_file?
    File.exists?(
      "config/services/#{@theme}/#{@base_path}.json"
    )
  end

  def content_item
    SchemaFinderService.new(
      base_path: "#{@theme}/#{@base_path}"
    ).content_item
  end
end
