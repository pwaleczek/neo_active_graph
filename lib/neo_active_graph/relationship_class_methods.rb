module NeoActiveGraph
  module RelationshipClassMethods
    def create properties={}
      _store properties
    end

    def find attrs
      # puts attrs
      relationship = NeoActiveGraph.db.get_relationship id
      properties = NeoActiveGraph.db.get_relationship_properties(relationship) || {}

      instance = new Hash[properties.map{ |k, v| [k.to_sym, v] }]
      instance.relationship = relationship
      instance
    end

    def _store properties={}
      instance = new properties

      # remove nil valued properties
      properties.each do |key, val|
        properties.delete(key) if val.nil?
      end

      return false unless _create_relationship instance, properties

      _set_label instance

      instance
    end

    def _set_label instance
      # add if label given in the model
      NeoActiveGraph.db.set_label instance.relationship, instance.label if instance.label
    end

    def _create_relationship instance, properties
      instance.relationship = NeoActiveGraph.db.create_relationship properties if instance.unique.nil?

      begin
        instance.relationship = NeoActiveGraph.db.create_or_fail_unique_relationship instance.unique[:name], instance.unique[:key], properties[instance.unique[:key]], properties
      rescue Exception => exception
        @errors[:db] = "Failed to create relationship"
        return false
      end if !instance.unique.nil?

      instance
    end
  end
end
