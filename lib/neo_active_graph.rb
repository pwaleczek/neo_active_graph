require 'neography'
require 'neo4j-cypher'
require 'neo4j-cypher/neography'
require 'neo_active_graph/query'
require 'neo_active_graph/validator'
# require 'neo_active_graph/active_record_compatibility'
require 'neo_active_graph/schema'
require 'neo_active_graph/node'
require 'neo_active_graph/relationship'

module NeoActiveGraph

  def self.configure config={}
    case config
    when Neography::Rest
      @rest = config
    when String
      @rest = Neography::Rest.new(config)
    else
      # running locally
      @rest = Neography::Rest.new
    end


  end

  def self.db
    @rest || Neography::Rest.new
  end

end
