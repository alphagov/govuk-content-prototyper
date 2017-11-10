module BrowseHelper
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
    ],
  }.freeze

  OVERRIDE_MARRIAGE_DIVORCE_PAGES = {
    '/browse/births-deaths-marriages/marriage-divorce' => [
      {
        title: 'Get a divorce: step by step',
        base_path: '/services/get-a-divorce'
      },
      {
        title: 'End a civil partnership: step by step',
        base_path: '/services/end-a-civil-partnership'
      }
    ]
  }

  DISABLE_BROWSE_LINKS = [
    '/divorce',
    '/end-civil-partnership',
    '/separation-divorce'
  ].freeze

  def divorced_section?(title)
    title == "Getting separated or divorced"
  end

  def disable_browse_link?(base_path)
    DISABLE_BROWSE_LINKS.include?(base_path)
  end

  def browsing_in_top_level_page?(top_level_page)
    request.path.starts_with?(top_level_page.base_path)
  end

  def browsing_in_second_level_page?(section)
    request.path.starts_with?(section.base_path)
  end

  def override_divorce_browse_page?(title)
    divorced_section?(title) &&
    OVERRIDE_MARRIAGE_DIVORCE_PAGES.keys.include?(path)
  end

  def divorce_service_browse_links
    OVERRIDE_MARRIAGE_DIVORCE_PAGES[path]
  end

  def override_browse_page?(params)
    OVERRIDE_BROWSE_PAGES.keys.include?(path)
  end

  def override_browse_page_with(params)
    OVERRIDE_BROWSE_PAGES[path]
  end

  def path
    "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}"
  end
end
