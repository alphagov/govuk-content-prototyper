class OverrideNavigationComponentsService

  def self.pages_to_override
    file = File.read("config/service_pages/overridden_pages.json")
    JSON.parse(file).keys
  end


  def initialize(item)
  end

  def override!
  end

private

  # TODO: implementation
end
