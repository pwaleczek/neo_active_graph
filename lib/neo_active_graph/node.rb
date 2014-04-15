require 'neo_active_graph/node_class_methods'

module NeoActiveGraph
  class Node < NeoActiveGraph::Schema

    class << self
      include NeoActiveGraph::NodeClassMethods

      attr_accessor :node
    end

    def initialize properties={}
      # if this is nil then the node has not yet been created in the db
      @node ||= nil

      super properties
    end

    def save
      return false unless self.valid?

      @filters[:before].each do |method|
        self.send(method) if self.respond_to? method
      end if @filters[:before]

      properties = get_properties_from_object

      if @node # results from the db -> node is present so update props
        self.node['data'] = NeoActiveGraph.db.set_node_properties(@node, properties).inject({}){ |hash, (k, v)| hash.merge( k.to_s => v ) }
      else # nothing in the db, need to make a node
        instance = self.class._store properties
        self.errors = instance.errors if instance
        self.node = instance.node if instance

        return false unless instance.errors.empty?
      end

      @filters[:after].each do |method|
        self.send(method) if self.respond_to? method
      end if @filters[:after]

      self
    end

    def relationships type="all"
      return nil unless @node
      # ...TODO
    end

    def id
      if @node
        @node["self"].split("/").last.to_i
      else
        'id'
      end
    end

    def persisted?
      !@node.nil?
    end

    def node; @node; end
    def node= node; @node = node; end

    # for compatibility reasons
    alias_method :neo_id, :id
  end
end
