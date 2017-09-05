class TaskNavigationService

  def initialize(schema_name: 'how-to-drive-a-car', base_path:)
    @schema_name = schema_name
    @base_path = formatted_base_path(base_path)
    @file = File.read("config/task_nav/#{schema_name}.json")
  end

  def applicable_content?
    task_navigation_supported? || is_secondary_content?
  end

  def task_navigation_supported?
    supported_paths.any?{ |path| path.start_with? @base_path }
  end

  def is_secondary_content?
    @base_path.start_with?(*secondary_content)
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

  def secondary_content
    @secondary_content ||= navigation_config.dig("links", "secondary_content") || []
  end

  def formatted_base_path(base_path)
    return unless base_path
    base_path.start_with?("/") ? base_path : "/#{base_path}"
  end

  def supported_paths
    @supported_paths ||= navigation_config.dig(
      "links", "ordered_tasks", "links"
    ).flatten.flat_map { |link| link["task_items"] }.map { |item| item["base_path"]}
    .compact
  end
end
