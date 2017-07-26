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

  # keep this method for now
  # might be useful to use it for other themes other than learn to drive.
  def task_links
    ordered_tasks = content_item.dig('links', 'ordered_steps').flat_map do |step|
      step["links"]["ordered_tasks"]
    end

    ordered_tasks.map! { |task| task["base_path"] }
    ordered_tasks.select(&:present?)
  end
end
