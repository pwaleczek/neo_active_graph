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

    # create an index for the UniqueModel
    NeoActiveGraph.db.create_node_index "Person_Idx", "exact", "lucene"

    class UniqueModel < NeoActiveGraph::Node
      unique "Person_Idx", :email
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

  it 'fails to create a duplicate unique node' do
    node1 = UniqueModel.create :name => "John Doe", :email => "john.doe@mail.com"
    node1.should be_valid
    node1.persisted?.should be true

    node2 = UniqueModel.create :name => "John Doe", :email => "john.doe@mail.com"
    node2.persisted?.should be false
    node2.errors.should include :database => ["john.doe@mail.com already exists."]
  end

  it 'sets node properties' do
    node = NodeModel.new
    node.name = "John Rambo"
    node.email = "john@rambo.com"
    node.persisted?.should be false
    node.save.should be_a NeoActiveGraph::Node
    node.persisted?.should be true
  end

  it 'updates node properties' do
    node = NodeModel.new
    node.name = "John Rambo"
    node.email = "john@rambo.com"
    node.persisted?.should be false
    node.save.should be_a NeoActiveGraph::Node
    node.persisted?.should be true
    node.name = "Shirley Temple"
    node.email = "shirley@temple.com"
    node.save.should be_a NeoActiveGraph::Node
    node.node['data'].should include :name.to_s => "Shirley Temple"
    node.node['data'].should include :email.to_s => "shirley@temple.com"
  end

  it 'removes a node from the db'

  it 'has relationships' do
    node1 = NodeModel.create :name => "John Doe", :email => "john.doe@mail.com"
    node1.should be_valid
    node1.persisted?.should be true

    node2 = NodeModel.create :name => "Joana Doe", :email => "joana.doe@mail.com"
    node2.should be_valid
    node2.persisted?.should be true

    NeoActiveGraph.db.create_relationship("lives_with", node1.node, node2.node)

    node1.relationships[0].should be_a(Hash)
    node1.relationships[0]['type'].should eq "lives_with"
  end


end
