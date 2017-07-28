module ApplicationHelper
  OVERRIDE_BROWSE_PAGES = {
    '/browse/driving/driving-licences' => [
      {
        title: 'Learn to drive a car',
        base_path: '/services/learn-to-drive-a-car'
      }
    ],
    '/browse/driving/learning-to-drive' => [
      {
        title: 'Learn to drive a car',
        base_path: '/services/learn-to-drive-a-car'
      },
      {
        title: 'Learn to ride a motorcycle or moped',
        base_path: '#'
      },
      {
        title: 'Learn to drive a tractor or specialist vehicle',
        base_path: '#'
      }
    ]
  }

  def override_sidebar?(base_path:)
    # TODO: find a way to not hardcode the base_path
    schema = SchemaFinderService.new(base_path: '/learn-to-drive-a-car')
    schema.task_links.include?("/#{base_path}")
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
end
