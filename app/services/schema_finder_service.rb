class SchemaFinderService
  def self.find(base_path:)
    file = File.read("config/services/#{base_path}.json")
    JSON.parse(file, object_class: OpenStruct)
  end
end
