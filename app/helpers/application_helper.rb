module ApplicationHelper
  OVERRIDE_BROWSE_PAGES = {
    '/browse/driving/driving-licences' => [
      {
        title: 'Learn to drive a car: step by step',
        base_path: '/services/learn-to-drive-a-car'
      }
    ],
    '/browse/driving/learning-to-drive' => [
      {
        title: 'Learn to drive a car: step by step',
        base_path: '/services/learn-to-drive-a-car'
      }
    ]
  }

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

  # argh duplication

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

  def set_tasklist(tasklist)
    session[:tasklist] = tasklist
  end

  def get_tasklist
    if not defined? session[:tasklist] or session[:tasklist] == nil
      if on_divorce_url
        set_tasklist('divorce')
      elsif on_civil_url
        set_tasklist('civil')
      end
    end
    session[:tasklist]
  end

  def highlight_sidebar_step?(ordered_tasks)
    ordered_tasks.map(&:base_path).include?("/#{params[:base_path]}")
  end

  def page_is_in_task_group?(task_group)
    base_path = "/#{params['base_path']}"
    task_group.any? do |task|
      links = task["task_items"].map { |task| task["base_path"] }
      links.include? base_path
    end
  end

  def browsing_in_top_level_page?(top_level_page)
    request.path.starts_with?(top_level_page.base_path)
  end

  def browsing_in_second_level_page?(section)
    request.path.starts_with?(section.base_path)
  end

  def override_browse_page?(params)
    path = "/browse/driving/#{params[:second_level_slug]}"
    OVERRIDE_BROWSE_PAGES.keys.include?(path)
  end

  def override_browse_page_with(params)
    path = "/browse/driving/#{params[:second_level_slug]}"
    OVERRIDE_BROWSE_PAGES[path]
  end

  def render_popular_list?
    return false if params[:second_level_slug] == "learning-to-drive"
    true
  end

  def hairspace(string)
    string.gsub(/\s/, "\u200A") # \u200A = unicode hairspace
  end
end
