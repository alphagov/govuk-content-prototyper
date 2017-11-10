module CivilpartnershipHelper
  CIVIL_URLS = [
    [
      '/services/end-a-civil-partnership',
      '/end-civil-partnership',
      '/end-civil-partnership/grounds-for-ending-a-civil-partnership'
    ],
    [
      '/services/end-a-civil-partnership',
      '/looking-after-children-divorce',
      '/money-property-when-relationship-ends'
    ],
    [
      '/services/end-a-civil-partnership',
      '/end-civil-partnership/file-application',
      '/end-civil-partnership/file-application',
      '/get-help-with-court-fees',
      '/divorce-missing-husband-wife',
      '/end-civil-partnership/if-your-partner-lacks-mental-capacity',
      '/divorce-missing-husband-wife'
    ],
    [
      '/services/end-a-civil-partnership',
      '/end-civil-partnership/apply-for-a-conditional-order',
      '/find-a-legal-adviser',
    ],
    [
      '/services/end-a-civil-partnership',
      '/end-civil-partnership/apply-for-a-final-order'
    ]
  ]

  def on_civil_url
    result = false
    CIVIL_URLS.each do |url|
      if url.include? request.path
        result = true
      end
    end
    result
  end

  def on_civil_step(step, highlighting = 0)
    if highlighting and CIVIL_URLS[step - 1].include? request.path # steps start at 1, let's not get confused
      true
    end
  end
end
