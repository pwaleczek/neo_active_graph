require 'neography'
require 'neo_active_graph/config'
require 'neo_active_graph/schema'
require 'neo_active_graph/node'

module NeoActiveGraph

  def self.configure neography_rest={}
    @rest = neography_rest ||= Neography::Rest.new
  end

  def self.db
    @rest
  end

end
