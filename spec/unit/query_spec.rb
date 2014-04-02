require 'spec_helper'
require 'neo_active_graph'
require 'neo_active_graph/query'

describe 'NeoActiveGraph::Query' do

  before do
    NeoActiveGraph.configure 'http://localhost:7475' unless ENV["TRAVIS"]
  end

  it 'has an alias for execute method' do
    NeoActiveGraph::Query.should respond_to :execute
    NeoActiveGraph::Query.should respond_to :exec
  end

  it 'does a Cypher query passed as a String' do
    result = NeoActiveGraph::Query.execute("START n=node(*) MATCH (john {name: \"Charles Bronson\"}) RETURN john")
    result.should be_a Hash
  end

  it 'does a Cypher query passed as a block'

end
