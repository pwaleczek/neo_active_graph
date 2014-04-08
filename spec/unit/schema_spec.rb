require 'spec_helper'
require 'neo_active_graph'
require 'neo_active_graph/schema'

describe 'NeoActiveGraph::Schema' do

  before do
    class Model < NeoActiveGraph::Schema
      label 'TestLabel'
      unique 'UniqueIndex', :uniqueProperty
      property :name, :type => String
      property :age, :type => Fixnum
    end

    class OtherModel < NeoActiveGraph::Schema
      property :name, :type => String, :presence => true
      property :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end

    class SchemaModel < NeoActiveGraph::Schema
      property :name, :type => String
      property :age, :type => Fixnum
    end
  end

  it 'has a schema defined' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :schema
  end

  it 'creates a generic, empty Schema object' do
    schema = NeoActiveGraph::Schema.new
    schema.should be_valid
  end

  it 'can have a label' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :label
  end

  it 'can be unique' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :unique
  end

  it 'can have validators' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :validators
  end

  it 'creates property accessors for defined properties' do
    schema = SchemaModel.new :name => 'John', :age => 99
    schema.name.should eql 'John'
    schema.age.should eql 99

  end

  it 'is used to extend a model class' do
    model = Model.new
    model.should be_valid
  end

  it 'can have a label' do
    model = Model.new
    model.label.should eql 'TestLabel'
  end

  it 'can be unique' do
    model = Model.new
    model.unique.should be_a Hash
    model.unique.should include :name => 'UniqueIndex'
    model.unique.should include :key => :uniqueProperty
  end

  it 'can have properties' do
    model = Model.new :name => 'Johnie'
    model.should respond_to :name
    model.name.should eql 'Johnie'
  end

  it 'validates property types' do
    model = Model.new :name => 'John Doe'
    model.age = 98
    model.should be_valid
    model.errors.should be_empty
  end

  it 'validates property presence' do
    model = OtherModel.new
    model.should_not be_valid
    model.errors.should_not be_empty
  end

  it 'validates property format using RegExp' do
    model = OtherModel.new :name => "John Doe", :email => 'john.doe@mail.com'
    model.should be_valid
    model.name.should eq 'John Doe'
    model.errors.should be_empty
  end

  it 'han errors' do
    model = OtherModel.new
    model.errors.should respond_to :[]
  end

  it 'responds to property name methods' do
    model = Model.new
    model.should respond_to :name
    model.should respond_to :age
  end
end
