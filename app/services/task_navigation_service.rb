class TaskNavigationService

  def initialize(schema_name: 'how-to-become-a-childminder', base_path:)
    @schema_name = schema_name
    @base_path = formatted_base_path(base_path)
    @file = File.read("config/task_nav/#{schema_name}.json")
  end

  def task_navigation_supported?
    supported_paths.include?(@base_path)
  end

  def navigation_config
    @navigation_config ||= JSON.parse(@file) || {}
  end

  def task_number_for_page
    navigation_config.dig("links","ordered_tasks","links").each_with_index do |step, step_index|
      step.each_with_index do |task, task_index|
        return [step_index, task_index] if task["task_items"].any?{ |item| item["base_path"] == @base_path }
      end
    end
  end

  def task_for_page
    navigation_config.dig("links","ordered_tasks","links").flatten.detect do |task|
      task["task_items"].any?{ |item| item["base_path"] == @base_path }
    end
  end

private

  def formatted_base_path(base_path)
    "/#{base_path}" unless base_path.start_with?("/")
  end

  def supported_paths
    @supported_paths ||= navigation_config.dig(
      "links", "ordered_tasks", "links"
    ).flatten.flat_map { |link| link["task_items"] }.map { |item| item["base_path"]}
  end
end
