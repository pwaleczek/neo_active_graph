require 'neography'
require 'neo_active_graph/schema'
require 'neo_active_graph/node'

module NeoActiveGraph
  @rest = Neography::Rest.new(ENV['GRAPHENEDB_URL'])

  def self.db
    @rest
  end

end
