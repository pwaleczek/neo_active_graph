require 'spec_helper'
require 'neo_active_graph'
require 'neo_active_graph/node'

describe 'NeoActiveGraph::Node schema' do
  before do
    NeoActiveGraph.configure 'http://localhost:7475' unless ENV["TRAVIS"]
  end

  node_by_id = nil

  it 'creates a node without properties' do
    node = NeoActiveGraph::Node.new
    node.should be_valid
    # puts node.properties#.should be_a Hash
  end

  it 'creates a node with properties' do
    class NodeModel < NeoActiveGraph::Node
      property :name, :type => String
    end

    node = NodeModel.new :name => "Paweł"
    node.should be_valid
    node.properties.should be_a Hash
    node_by_id = node.id
  end

  it 'gets a node by id' do
    node = NeoActiveGraph::Node.find(node_by_id)
  end
end

