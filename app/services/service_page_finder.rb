class ServicePageFinder
  def self.find(base_path)
    file = File.read("config/service_pages/#{base_path}.json")
    JSON.parse(file, object_class: OpenStruct)
  rescue Errno::ENOENT
    return nil
  end
end
