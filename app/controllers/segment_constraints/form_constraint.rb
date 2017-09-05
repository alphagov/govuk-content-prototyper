class FormConstraint
  def matches?(request)
    content_item = request.env['content_item']
    content_item && guidance_content?(content_item)
  end

  def guidance_content?(content_item)
    content_item['navigation_document_supertype'] == 'guidance' &&
      ['forms', 'guidance'].include?(content_item['government_document_supertype'])
  end
end
