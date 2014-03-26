require 'neo_active_graph/schema'

describe 'NeoActiveGraph::Schema' do
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
end
