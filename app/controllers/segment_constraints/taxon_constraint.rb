class TaxonConstraint
  def matches?(request)
    is_taxon?(request.env['content_item'])
  end

  def is_taxon?(content_item)
    content_item && content_item['document_type'] == 'taxon'
  end
end
