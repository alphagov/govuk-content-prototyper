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
    ordered_tasks.select(&:present?) + pages_to_show_sidebar
  end

  def pages_to_show_sidebar
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
