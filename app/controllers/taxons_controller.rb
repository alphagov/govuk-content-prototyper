class TaxonsController < ApplicationController
  helper_method :taxon_overview_and_child_taxons

  def show
    locals = {
          taxon: taxon,
          navigation_helpers: navigation_helpers,
        }

    case taxon_path
    when '/education/funding-and-finance-for-students'
      render(:accordion_student_finance, layout: 'collections', locals: locals)
    when '/education/school-governance'
      render(:accordion_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          accordion_content: taxon_overview_and_child_taxons(taxon),
          taxon_with_sublist_base_path: '/education/school-governance-duties-and-responsibilities',
          leaf_template: 'leaf_school_governance',
        ),
      )
    when '/education/school-governance-duties-and-responsibilities'
      render(:leaf_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          tagged_content: taxon.tagged_content,
          leaf_template: 'leaf_school_governance',
        ))
    when '/education/special-educational-needs-and-disability-send-and-high-needs'
      render(:accordion_send, layout: 'collections', locals: locals.merge(accordion_content: taxon_overview_and_child_taxons(taxon)))
    when '/education/funding-for-school-buildings-and-land'
      render(:accordion_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          accordion_content: taxon_overview_and_child_taxons(taxon),
          taxon_with_sublist_base_path: '/education/current-funding-schemes',
          leaf_template: 'leaf_funding_for_school_buildings_and_land',
        ),
      )
    when '/education/current-funding-schemes'
      render(:leaf_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          tagged_content: taxon.tagged_content,
          leaf_template: 'leaf_funding_for_school_buildings_and_land',
        ))
    when '/education/pupil-premium-and-other-school-premiums'
      render(:accordion_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          accordion_content: taxon_overview_and_child_taxons(taxon),
          taxon_with_sublist_base_path: '/education/pupil-premium',
          leaf_template: 'leaf_pupil_premium',
        ),
      )
    when '/education/pupil-premium'
      render(:leaf_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          tagged_content: taxon.tagged_content,
          leaf_template: 'leaf_pupil_premium',
        ))
    when '/education/school-and-academy-financial-management-and-assurance'
      render(:accordion_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          accordion_content: taxon_overview_and_child_taxons(taxon),
          taxon_with_sublist_base_path: '/education/school-procurement',
          leaf_template: 'leaf_school_financial_management',
        ),
      )
    when '/education/school-procurement'
      render(:leaf_with_sublists,
        layout: 'collections',
        locals: locals.merge(
          tagged_content: taxon.tagged_content,
          leaf_template: 'leaf_school_financial_management',
        ))
    else
      render(:show, layout: 'collections', locals: locals)
    end
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
end
