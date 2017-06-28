class TaxonsController < ApplicationController
  helper_method :taxon_overview_and_child_taxons

  layout 'collections'

  def show
    setup_content_item_and_navigation_helpers(taxon)

    taxon_template = presented_taxon.rendering_type || :leaf

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render taxon_template, locals: {
      presented_taxon: presented_taxon,
      taxon: taxon
    }
  end

  private

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= TaxonPresenter.new(taxon)
  end
end
