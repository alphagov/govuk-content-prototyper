module ApplicationHelper
  def override_sidebar?(base_path:)
    # TODO: find a way to not hardcode the base_path
    schema = SchemaFinderService.new(base_path: '/learn-to-drive-a-car')
    schema.task_links.include?("/#{base_path}")
  end
end
