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
      },
      {
        title: 'Learn to ride a motorcycle or moped: step by step',
        base_path: '/services/learn-to-drive-a-car'
      },
      {
        title: 'Learn to drive a tractor or specialist vehicle: step by step',
        base_path: '/services/learn-to-drive-a-car'
      }
    ]
  }

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
