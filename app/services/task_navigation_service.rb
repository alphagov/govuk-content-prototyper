class TaskNavigationService

  def self.task_navigation_supported?(base_path)
    base_path = formatted_base_path(base_path)
    current.supported_paths.include?(base_path)
  end

  def initialize
    # @file = File.read("config/task_nav/how-to-become-a-childminder.json")
    @file = File.read("config/task_nav/how-to-drive-a-car.json")
  end

  def navigation_config
    @navigation_config ||= JSON.parse(@file)
  end

  def supported_paths
    @supported_paths ||= navigation_config.dig("links", "ordered_tasks", "links").flatten.map{ |link| link["task_items"] }.flatten.map{|item| item["base_path"]}
  end

  def self.task_number_for_page(base_path)
    base_path = formatted_base_path base_path
    current.navigation_config.dig("links","ordered_tasks","links").each_with_index do |step, step_index|
      step.each_with_index do |task, task_index|
        return [step_index, task_index] if task["task_items"].any?{ |item| item["base_path"] == base_path }
      end
    end
  end

  def self.task_for_page(base_path)
    base_path = formatted_base_path base_path
    current.navigation_config.dig("links","ordered_tasks","links").flatten.detect do |task|
      task["task_items"].any?{ |item| item["base_path"] == base_path }
    end
  end

  def self.current
    @current ||= new
  end

private

  def self.formatted_base_path(base_path)
    base_path = "/#{base_path}" unless base_path.start_with?("/")
  end
end
