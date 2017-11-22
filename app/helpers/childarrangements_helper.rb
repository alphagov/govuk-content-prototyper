module ChildarrangementsHelper
  CHILDARRANGEMENT_URLS = [
    [
      '/services/make-child-arrangements', # slight hack to make every step always appear on the main task list page
    ],
    [
      '/services/make-child-arrangements',
      '/parental-rights-responsibilities',
      '/parental-rights-responsibilities/who-has-parental-responsibility',
      '/parental-rights-responsibilities/apply-for-parental-responsibility'
    ],
    [
      '/services/make-child-arrangements',
      '/looking-after-children-divorce/if-you-agree'
    ],
    [
      '/services/make-child-arrangements',
    ],
    [
      '/services/make-child-arrangements',
      '/represent-yourself-in-court',
      '/looking-after-children-divorce/apply-for-court-order',
      '/get-help-with-court-fees',
      '/looking-after-children-divorce/after-you-apply-for-a-court-order'
    ],
    [
      '/services/make-child-arrangements',
      '/arranging-child-maintenance-yourself',
      '/calculate-your-child-maintenance',
      '/money-property-when-relationship-ends/apply-for-consent-order',
      '/child-maintenance'
    ]
  ]

  def on_childarrangements_url
    result = false
    CHILDARRANGEMENT_URLS.each do |url|
      if url.include? request.path
        result = true
      end
    end
    result
  end

  def on_childarrangements_step(step, on_sidebar = 0)
    if on_sidebar and CHILDARRANGEMENT_URLS[step - 1].include? request.path # steps start at 1, let's not get confused
      true
    end
  end
end
