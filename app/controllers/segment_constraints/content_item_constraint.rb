class ContentItemConstraint
  def matches?(request)
    guidance_content?(request.env['content_item'])
  end

  def guidance_content?(content_item)
    content_item && content_item['government_document_supertype'] != 'forms'
  end
end
