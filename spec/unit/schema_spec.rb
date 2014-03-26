require 'spec_helper'
require 'neo_active_graph/schema'

describe NeoActiveGraph::Schema do
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

  it 'can have properties' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :properties
  end

  it 'can have validators' do
    schema = NeoActiveGraph::Schema.new
    schema.should respond_to :validators
  end

  it 'is used to extend a model class' do
    class Model < NeoActiveGraph::Schema; end

    model = Model.new
    model.should be_valid
  end

  it 'model can have a label' do
    class Model < NeoActiveGraph::Schema
      label 'TestLabel'
    end

    model = Model.new
    expect(model.label).to eql 'TestLabel'
  end

  it 'model can be unique' do
    class Model < NeoActiveGraph::Schema
      unique 'UniqueIndex', :uniqueProperty
    end

    model = Model.new
    expect(model.unique).to be_a Hash
    expect(model.unique).to include :name => 'UniqueIndex'
    expect(model.unique).to include :key => :uniqueProperty
  end

  it 'model can have properties' do
    class Model < NeoActiveGraph::Schema
      property :name
    end

    model = Model.new

    model.should respond_to :name
  end
end
