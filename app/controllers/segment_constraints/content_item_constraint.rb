class ContentItemConstraint
  def matches?(request)
    guidance_content?(request.env['content_item'])
  end

  def guidance_content?(content_item)
    content_item && content_item['navigation_document_supertype'] == 'guidance'
  end
end
