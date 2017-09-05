class SchemaFinderService

  SERVICE_FILE_NAMES = %w(
    learn-to-drive-a-car
    how-to-become-a-childminder
  )

  def self.all
    @all ||= SERVICE_FILE_NAMES.map do |file_name|
      new(base_path: file_name)
    end
  end

  def self.taxonomy_supported?(base_path)
    base_path = "/#{base_path}"

    all.any? do |service|
      return false if service.learn_to_drive_a_car? && service.base_paths.include?(base_path)

      service.base_paths.include?(base_path)
    end
  end

  def initialize(base_path:)
    @file = File.read("config/services/#{base_path}.json")
  end

  def page_schema
    JSON.parse(@file, object_class: OpenStruct)
  end

  def content_item
    JSON.parse(@file)
  end

  def name
    page_schema.base_path.split('/').last
  end

  def learn_to_drive_a_car?
    name == 'learn-to-drive-a-car'
  end

  # keep this method for now
  # might be useful to use it for other themes other than learn to drive.
  def base_paths
    @base_paths ||= find_base_paths
  end

  def find_base_paths
    task_base_paths = ordered_task_groups.flatten.map { |task| task["base_path"] }

    if learn_to_drive_a_car?
      task_base_paths.select(&:present?) + learn_to_drive_pages_to_show_sidebar
    else
      task_base_paths.select(&:present?)
    end
  end

  def find_base_path_title(base_path)
    task = ordered_task_groups.flatten.find do |task|
      task["base_path"] == "/#{base_path}"
    end

    task["title"] if task
  end

  def ordered_task_groups
    @ordered_task_groups ||= extract_ordered_task_groups
  end

  def extract_ordered_task_groups
    task_groups = []
    ordered_steps.each do |group|
      group.flat_map do |step|
        task_groups << step["links"]["ordered_tasks"]
      end
    end

    task_groups
  end

  def ordered_steps
    @ordered_steps ||= content_item.dig('links', 'ordered_steps')
  end

  # This pages are not in the JSON service schema
  def learn_to_drive_pages_to_show_sidebar
    %w(
      /id-for-driving-licence
      /driving-lessons-learning-to-drive
      /theory-test
      /theory-test/multiple-choice-questions
      /theory-test/hazard-perception-test
      /theory-test/pass-mark-and-result
      /theory-test/reading-difficulty-disability-or-health-condition
      /theory-test/if-you-have-safe-road-user-award
      /driving-test
      /driving-test/what-happens-during-test
      /driving-test/driving-test-faults-result
      /driving-test/test-cancelled-bad-weather
      /driving-test/disability-health-condition-or-learning-difficulty
      /driving-test/using-your-own-car
      /driving-test/changes-december-2017
      /pass-plus
      /pass-plus/car-insurance-discounts
      /pass-plus/booking-pass-plus
      /pass-plus/local-councils-offering-discounts
      /pass-plus/how-pass-plus-training-works
      /pass-plus/apply-for-a-pass-plus-certificate
    )
  end
end
