module ApplicationHelper
  def override_sidebar?(base_path:)
    # TODO: find a way to not hardcode the base_path
    schema = SchemaFinderService.new(base_path: '/learn-to-drive-a-car')
    schema.task_links.include?("/#{base_path}")
  end

  def browsing_in_second_level_page?(section)
    request.path.starts_with?(section.base_path)
  end
end
