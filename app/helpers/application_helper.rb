module ApplicationHelper
  def set_tasklist(tasklist)
    session[:tasklist] = tasklist
  end

  def get_tasklist
    if not defined? session[:tasklist] or session[:tasklist] == nil
      if on_divorce_url
        set_tasklist('divorce')
      elsif on_civil_url
        set_tasklist('civil')
      elsif on_childarrangements_url
        set_tasklist('childarrangements')
      else
        set_tasklist(nil)
      end
    end
    session[:tasklist]
  end

  def on_this_page(url)
    if request.path == url
      true
    end
  end

  def in_more_than_one_tasklist
    matches = 0

    [on_divorce_url, on_civil_url, on_childarrangements_url].each do |match|
      if match
        matches += 1
      end
    end

    if matches > 1
      true
    end
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

  def render_popular_list?
    return false if params[:second_level_slug] == "learning-to-drive"
    true
  end

  def hairspace(string)
    string.gsub(/\s/, "\u200A") # \u200A = unicode hairspace
  end
end
