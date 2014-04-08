require 'spec_helper'
require 'neo_active_graph'
require 'neo_active_graph/node'

describe 'NeoActiveGraph::Relationship' do

  before do
    NeoActiveGraph.configure 'http://localhost:7475' unless ENV["TRAVIS"]

    # class NodeModel < NeoActiveGraph::Node
    #   label "Person"
    #   property :name, :type => String
    #   property :email, :type => String, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # end
  end

  it 'creates a relationship between 2 nodes'
  it 'can have a label'
  it 'can have properties'
  it 'retrieves a relationship by id'

end
