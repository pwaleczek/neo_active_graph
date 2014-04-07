require 'spec_helper'
require 'neo_active_graph'
require 'neo_active_graph/node'

describe 'NeoActiveGraph::Node' do
  before do
    NeoActiveGraph.configure 'http://localhost:7475' unless ENV["TRAVIS"]

    class NodeModel < NeoActiveGraph::Node
      label "Person"
      property :name, :type => String
      property :email, :type => String, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end
  end

  by_id_1 = nil
  by_id_2 = nil

  it 'creates a node without properties' do
    node = NodeModel.create
    node.should be_a NeoActiveGraph::Node
    node.should be_valid

    by_id_1 = node.id
    # puts node.properties#.should be_a Hash
  end

  it 'creates a node with properties' do
    node = NodeModel.create :name => "Charles Bronson"
    node.should be_a NeoActiveGraph::Node
    node.should be_valid
    node.properties.should be_a Hash
    node.name.should eql 'Charles Bronson'
    by_id_2 = node.id
  end

  it 'creates a node instance and saves it' do
    node = NodeModel.new
    node.name = 'Charlie Sheen'
    node.save.should be_a NeoActiveGraph::Node
    node.name.should eq 'Charlie Sheen'
  end


  it 'gets a node by id' do
    node = NodeModel.find(by_id_2)
    node.should be_a NeoActiveGraph::Node
    node.id.should eql by_id_2
    node.name.should eql 'Charles Bronson'
  end

  it 'gets multiple nodes by id' do
    nodes = NodeModel.find([by_id_1, by_id_2])
    nodes.should be_an Array
    nodes.each do |node|
      node.should be_a NeoActiveGraph::Node
      if node.id == by_id_2
        node.name.should eql 'Charles Bronson'
      end
    end
  end

  it 'verifies if node is already in the db' do
    node = NodeModel.new
    node.should be_valid
    node.persisted?.should be false
  end

  it 'sets node properties' do
    node = NodeModel.new
    node.name = "John Rambo"
    node.email = "john@rambo.com"
    node.persisted?.should be false
    puts node.properties
    node.save.should be_a NeoActiveGraph::Node
    puts node.properties
    # sleep 2
    # puts node.persisted?

    # puts node.node
    # node.persisted?.should be true
  end
  it 'updates node properties'
  it 'resets node properties'


end
