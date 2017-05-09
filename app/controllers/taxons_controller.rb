class TaxonsController < ApplicationController
  helper_method :taxon_overview_and_child_taxons
  helper_method :mainstream_content

  def show
    render :show,
      layout: 'collections',
      locals: {
        taxon: taxon,
        navigation_helpers: navigation_helpers,
        mainstream_formats: mainstream_formats,
      }
  end

  private

  def taxon_overview_and_child_taxons(taxon)
    accordion_items = taxon.child_taxons
    return [] if taxon.child_taxons.empty?

    current_taxon_title = 'General information and guidance'

    if taxon.tagged_content.count > 0
      guidance_taxon = Taxon.new(
        'content_id' => taxon.content_id,
        'base_path' => taxon.base_path,
        'title' => current_taxon_title,
        'description' => taxon.to_hash['accordion_description'] || ''
      )
      guidance_taxon.has_tagged_content = true

      accordion_items.unshift(guidance_taxon)
    end

    accordion_items
  end

  def navigation_helpers
    @navigation_helpers ||=
      GovukNavigationHelpers::NavigationHelper.new(taxon.to_hash)
  end

  def taxon
    @taxon ||= Taxon.new(env['content_item'])
  end

  def taxon_path
    "/#{params[:base_path]}"
  end

  def mainstream_formats
    [
      "answer",
      "calculator",
      "calendar",
      "completed_transaction",
      "guide",
      "local_transaction",
      "place",
      "programme",
      "simple_smart_answer",
      "smart_answer",
      "transaction"
    ]
  end

  def mainstream_content(taxon)
    return_array = []

    return_array << taxon.tagged_content.select do |content_item|
      mainstream_formats.include? content_item.content_store_document_type
    end

    taxon.child_taxons.each do |child|
      return_array << child.tagged_content.select do |content_item|
        mainstream_formats.include? content_item.content_store_document_type
      end
    end

    return_array.flatten.uniq{|item| item.base_path}.sort_by(&:title)
  end
end
