module DivorceHelper
  DIVORCE_URLS = [
    [
      '/services/get-a-divorce', # slight hack to make every step always appear on the main task list page
      '/divorce',
      '/divorce/grounds-for-divorce'
    ],
    [
      '/services/get-a-divorce',
      '/looking-after-children-divorce',
      '/money-property-when-relationship-ends'
    ],
    [
      '/services/get-a-divorce',
      '/divorce/file-for-divorce', # this occurs twice
      '/get-help-with-court-fees',
      '/divorce-missing-husband-wife', # so does this
      '/divorce/if-your-husband-or-wife-lacks-mental-capacity'
    ],
    [
      '/services/get-a-divorce',
      '/divorce/apply-for-decree-nisi',
      '/find-a-legal-adviser'
    ],
    [
      '/services/get-a-divorce',
      '/divorce/apply-for-a-decree-absolute'
    ]
  ]

  def on_divorce_url
    result = false
    DIVORCE_URLS.each do |url|
      if url.include? request.path
        result = true
      end
    end
    result
  end

  def on_divorce_step(step, highlighting = 0)
    if highlighting and DIVORCE_URLS[step - 1].include? request.path # steps start at 1, let's not get confused
      true
    end
  end
end
