class TaxonConstraint
  THEMES = %w[
    education
  ].freeze

  def matches?(request)
    THEMES.include?(request.path_parameters[:theme])
  end
end