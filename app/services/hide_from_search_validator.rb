class HideFromSearchValidator
  attr_reader :base_path

  def initialize(base_path)
    @base_path = base_path
  end

  def valid?(document)
    return true unless hide_from_search_mapping.present?

    hide_from_search_mapping.exclude?(document.base_path)
  end

  private

  def hide_from_search_mapping
    @hide_from_search_mapping ||=
      Config.search_overrides[base_path]
  end
end
