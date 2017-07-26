module ApplicationHelper
  LEARN_TO_DRIVE_BASE_PATHS = [
    "vehicles-can-drive",
    "driving-eyesight-rules",
    "apply-first-provisional-driving-licence",
    "track-your-driving-licence-application",
    "driving-lessons-learning-to-drive/taking-driving-lessons",
    "driving-lessons-learning-to-drive/practising-with-family-or-friends",
    "driving-test",
    "driving-lessons-learning-to-drive/using-l-and-p-plates",
    "government/publications/car-show-me-tell-me-vehicle-safety-questions",
    "complain-about-a-driving-instructor",
    "report-an-illegal-driving-instructor",
    "theory-test",
    "take-practice-theory-test",
    "book-theory-test",
    "change-theory-test",
    "check-theory-test",
    "cancel-theory-test",
    "book-driving-test",
    "change-driving-test",
    "check-driving-test",
    "cancel-driving-test",
    "find-theory-test-pass-number",
    "apply-for-your-full-driving-licence"
  ].freeze

  def override_sidebar?(base_path)
    LEARN_TO_DRIVE_BASE_PATHS.include?(base_path)
  end
end
