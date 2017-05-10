require 'gds_api/rummager'

module Services
  def self.rummager
    @rummager ||= Rummager.new
  end

  class Rummager
    def search(args)
      rummager.search(args)
    end

    private

    def rummager
      @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
    end
  end
end
