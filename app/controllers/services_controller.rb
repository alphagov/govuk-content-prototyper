class ServicesController < ApplicationController
  def show
    @page_schema = ServincePageFinder.find(params[:base_path])
  end

  class ServincePageFinder
    def self.find(base_path)
      JSON.parse(
        File.read("config/service_pages/#{base_path}.json")
      ).with_indifferent_access
    rescue Errno::ENOENT
      return nil
    end
  end
end
