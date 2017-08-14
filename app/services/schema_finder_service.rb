class SchemaFinderService

  SERVICE_FILE_NAMES = %w(
    learn-to-drive-a-car
    how-to-become-a-childminder
  )

  def self.all
    SERVICE_FILE_NAMES.map do |file_name|
      new(base_path: file_name)
    end
  end

  def self.taxonomy_supported?(base_path)
    base_path = "/#{base_path}"

    all.any? do |service|
      return false if service.learn_to_drive_a_car? && service.task_links.include?(base_path)

      service.task_links.include?(base_path)
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
  def task_links
    ordered_tasks = content_item.dig('links', 'ordered_steps').flat_map do |step|
      step["links"]["ordered_tasks"]
    end

    ordered_tasks.map! { |task| task["base_path"] }

    if learn_to_drive_a_car?
      ordered_tasks.select(&:present?) + learn_to_drive_pages_to_show_sidebar
    else
      ordered_tasks.select(&:present?)
    end
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
