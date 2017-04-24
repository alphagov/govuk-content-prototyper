class ExampleResult
  attr_reader :example

  def initialize(example)
    @example = example
  end

  def document_type
    example.dig('value', 'slug')
  end

  def title
    example.dig('value', 'example_info', 'examples')[0]['title']
  end

  def link
    example.dig('value', 'example_info', 'examples')[0]['link']
  end
end
