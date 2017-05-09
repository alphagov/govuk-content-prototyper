require 'gds_api/rummager'
require 'search_mutator'

module Services
  def self.rummager
    @rummager ||= Rummager.new
  end

  class Rummager
    def search(args)
      results = rummager.search(args)
      SearchMutator.mutate_search(results)
    end

    private

    def rummager
      @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
    end
  end
end
