require 'neo_active_graph/schema'

describe 'Model < NeoActiveGraph::Schema' do

  it 'is used to extend a model class' do
    class Model < NeoActiveGraph::Schema; end

    model = Model.new
    model.should be_valid
  end

  it 'can have a label' do
    class Model < NeoActiveGraph::Schema
      label 'TestLabel'
    end

    model = Model.new
    model.label.should eql 'TestLabel'
  end

  it 'can be unique' do
    class Model < NeoActiveGraph::Schema
      unique 'UniqueIndex', :uniqueProperty
    end

    model = Model.new
    model.unique.should be_a Hash
    model.unique.should include :name => 'UniqueIndex'
    model.unique.should include :key => :uniqueProperty
  end

  it 'can have properties' do
    class Model < NeoActiveGraph::Schema
      property :name
    end

    model = Model.new

    model.should respond_to :name
    model.name.should be_nil
  end

  it 'has required properties' do
    class Model < NeoActiveGraph::Schema
      property :name, :presence => true
    end

    model = Model.new
    model.should_not be_valid
    model.errors.should_not be_empty
  end

  it 'validates property types' do
    class Model < NeoActiveGraph::Schema
      property :name, :type => String
    end

    model = Model.new(:name => 'John Doe')
    model.should be_valid
  end

  it 'validates property format using RegExp' do
    class Model < NeoActiveGraph::Schema
      property :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end

    model = Model.new(:email => 'john.doe@mail.com')
    model.should be_valid
  end
end
