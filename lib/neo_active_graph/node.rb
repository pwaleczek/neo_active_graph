module NeoActiveGraph
  class Node < NeoActiveGraph::Schema

    class << self
      def create properties={}
        _store properties
      end

      def find attrs
        # puts attrs
        case attrs
        when Fixnum # only one node id specified
          _find_single attrs
        when Array # more than one, return an Array of node instances
          _find_multi attrs
        end
      end

      def _find_single id
        node = NeoActiveGraph.db.get_node id

        properties = NeoActiveGraph.db.get_node_properties(node) || {}

        instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
        instance.node = node

        instance
      end

      def _find_multi ids
        nodes = NeoActiveGraph.db.get_nodes ids

        instances = []

        nodes.each do |node|
          properties = NeoActiveGraph.db.get_node_properties(node) || {}

          instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
          instance.node = node
          instances.push instance
        end #if nodes

        instances
      end

      def _store properties={}
        instance = new properties

        # remove nil valued properties
        properties.each do |key, val|
          properties.delete(key) if val.nil?
        end
        _create_node instance, properties
        # add if label given in the model
        _set_label instance

        instance
      end

      def _set_label instance
        NeoActiveGraph.db.set_label instance.node, instance.label if instance.label
      end

      def _create_node instance, properties
        if instance.unique.nil?
          instance.node = NeoActiveGraph.db.create_node properties
        else
          instance.node = NeoActiveGraph.db.create_unique_node instance.unique[:name], instance.unique[:key], properties[instance.unique[:key]], properties
        end
      end
      attr_accessor :node
    end

    def initialize properties={}
      super properties
    end

    def save
      return unless self.valid?

      @filters[:before].each do |method|
        method unless self.respond_to?(method)
      end if @filters[:before]

      if @node # results from the db -> node is present so update props
        NeoActiveGraph.db.set_node_properties(@node, @properties)
      else # nothing in the db, need to make a node
        self.class._store @properties
      end

      @filters[:after].each do |method|
        method unless self.respond_to?(method)
      end if @filters[:after]

      self

    end

    def relationships name, type="all"

    end

    def id
      if @node
        @node["self"].split("/").last.to_i
      else
        'id'
      end
    end

    def node; @node; end
    def node= node; @node = node; end

    # for compatibility reasons
    alias_method :neo_id, :id
  end
end
