module NeoActiveGraph
  class Node < NeoActiveGraph::Schema

    def initialize properties={}
      super properties

      return if properties.empty?

      create @properties

      # self.class.after_filters.each do |method|
      #   method unless self.respond_to?(method)
      # end

    end

  private

    def create *properties
      node = nil

      if @unique.nil?
        node = Graph.db.create_node *properties
      else
        node = Graph.db.create_unique_node @unique[:name], @unique[:key], Hash[*properties][@unique[:key].to_sym], *properties

      end

      Graph.db.set_label node, @label if @label

    end

    # def self.properties *attrs
    #   @db.get_node_properties attrs
    # end

    # def self.to_index *attrs
    #   @db.add_node_to_index attrs
    # end
  end
end
