class Taxon
  attr_reader :content_item
  attr_accessor :has_tagged_content

  def initialize(content_item)
    @content_item = content_item.to_hash
  end

  def self.find(base_path)
    content_item = Services.content_store.content_item(base_path)
    new(content_item.to_hash)
  end

  %w(content_id base_path title description).each do |method_name|
    define_method method_name do
      content_item.fetch(method_name)
    end
  end

  def to_hash
    content_item
  end

  def linked_items(link_type)
    content_item.dig('links', link_type)
  end

  def children?
    linked_items('child_taxons').present?
  end

  def child_taxons
    return [] unless children?

    children = linked_items('child_taxons').map do |child_taxon|
      self.class.new(child_taxon)
    end

    children.sort_by(&:title)
  end

  def grandchildren?
    return false unless children?

    # The Publishing API doesn't expand child taxons, which means
    # we can't use the child_taxons method for each of the child
    # taxons of this taxon. We have to do an API call to know if
    # the children also have children.
    child_taxons.any? do |child_taxon|
      Taxon.find(child_taxon.base_path).children?
    end
  end

  def tagged_content
    @tagged_content ||= TaggedContent.fetch(
      content_id: content_id,
      base_path: base_path
    )
  end
end
