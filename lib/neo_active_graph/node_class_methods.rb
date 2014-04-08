module NeoActiveGraph
  module NodeClassMethods
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

    def _instance_from_node node
      properties = NeoActiveGraph.db.get_node_properties(node) || {}

      instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
      instance.node = node

      instance
    end

    def _find_single id
      node = NeoActiveGraph.db.get_node id

      _instance_from_node node
    end

    def _find_multi ids
      nodes = NeoActiveGraph.db.get_nodes ids

      instances = []

      nodes.each do |node|
        instances.push _instance_from_node node
      end #if nodes

      instances
    end

    def _store properties={}
      instance = new properties

      # remove nil valued properties
      properties.each do |key, val|
        properties.delete(key) if val.nil?
      end

      return false unless _create_node instance, properties
      # add if label given in the model
      _set_label instance

      instance
    end

    def _set_label instance
      NeoActiveGraph.db.set_label instance.node, instance.label if instance.label
    end

    def _create_node instance, properties
      instance.node = NeoActiveGraph.db.create_node properties if instance.unique.nil?

      begin
        instance.node = NeoActiveGraph.db.create_or_fail_unique_node instance.unique[:name], instance.unique[:key], properties[instance.unique[:key]], properties
      rescue Neography::OperationFailureException => exception
        # @errors[:db] = "Failed to create node"
        return false
      end if !instance.unique.nil?

      instance
    end
  end
end
