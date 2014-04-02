module NeoActiveGraph
  class Relationship < NeoActiveGraph::Schema

    class << self
      def create properties={}
        instance = new properties

        if instance.unique.nil?
          instance.node = NeoActiveGraph.db.create_node properties
        else
          instance.node = NeoActiveGraph.db.create_unique_node instance.unique[:name], instance.unique[:key], Hash[*properties][instance.unique[:key].to_sym], properties
        end

        NeoActiveGraph.db.set_label instance.node, instance.label if instance.label

        instance
      end

      def find attrs
        # puts attrs
        case attrs
        when Fixnum
          node = NeoActiveGraph.db.get_node attrs
          properties = NeoActiveGraph.db.get_node_properties(node) || {}
          instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
          instance.node = node
          return instance
        when Array
          nodes = NeoActiveGraph.db.get_nodes attrs
          instances = []
          nodes.each do |node|
            properties = NeoActiveGraph.db.get_node_properties(node) || {}
            instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
            instance.node = node
            instances.push instance
          end #if nodes

          return instances
        end
      end

      attr_accessor :node
    end

    def initialize properties
      super properties

    end

  end
end
