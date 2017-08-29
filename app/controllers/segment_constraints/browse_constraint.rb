class BrowseConstraint
  def matches?(request)
    request.path == "/childcare-parenting/providing-childcare"
  end
end
