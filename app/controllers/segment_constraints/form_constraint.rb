class FormConstraint
  def matches?(request)
    content_item = request.env['content_item']
    content_item && (guidance_content?(content_item) || content_item['base_path'] == "/government/publications/become-a-registered-early-years-or-childcare-provider-in-england")
  end

  def guidance_content?(content_item)
    content_item['navigation_document_supertype'] == 'guidance' && content_item['government_document_supertype'] == 'forms'
  end
end
