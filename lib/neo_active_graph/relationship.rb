require 'neo_active_graph/relationship_class_methods'

module NeoActiveGraph
  class Relationship < NeoActiveGraph::Schema

    class << self
      include NeoActiveGraph::RelationshipClassMethods

      attr_accessor :relationship
    end

    def initialize properties={}
      # if this is nil then the relationship has not yet been created in the db
      @relationship ||= nil

      super properties
    end

    def save
      return unless self.valid?

      @filters[:before].each do |method|
        method unless self.respond_to? method
      end if @filters[:before]

      properties = get_properties_from_object

      if @relationship # results from the db -> relationship is present so update props
        self.relationship['data'] = NeoActiveGraph.db.set_relationship_properties(@relationship, properties).map{ |k, v| {k.to_s => v} }[0]
      else # nothing in the db, need to make a relationship
        instance = self.class._store properties

        self.relationship = instance.relationship

        return false unless instance
      end

      @filters[:after].each do |method|
        method unless self.respond_to? method
      end if @filters[:after]

      self
    end

    def id
      if @relationship
        @relationship["self"].split("/").last.to_i
      else
        'id'
      end
    end

    def persisted?
      !@relationship.nil?
    end

    def relationship; @relationship; end
    def relationship= relationship; @relationship = relationship; end

    # for compatibility reasons
    alias_method :neo_id, :id
  end
end
