class SchemaFinderService

  def initialize(base_path:)
    @file = File.read("config/services/#{base_path}.json")
  end

  def page_schema
    JSON.parse(@file, object_class: OpenStruct)
  end

  def content_item
    JSON.parse(@file)
  end
end
