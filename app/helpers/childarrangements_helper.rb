module ChildarrangementsHelper
  CHILDARRANGEMENT_URLS = [
    [
      '/services/make-child-arrangements', # slight hack to make every step always appear on the main task list page
    ],
    [
      '/services/make-child-arrangements',
    ],
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
