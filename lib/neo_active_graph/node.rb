require 'neo_active_graph/schema'

module NeoActiveGraph
  class Node < NeoActiveGraph::Schema

    class << self
      def find attrs
        case attrs
        when Fixnum
          node = NeoActiveGraph.db.get_node attrs
        when Array
          nodes = NeoActiveGraph.db.get_nodes attrs
        end

      end
    end

    def initialize properties={}
      super properties

      # return if properties.empty?

      create @properties

      # self.class.after_filters.each do |method|
      #   method unless self.respond_to?(method)
      # end

    end

    def id
      @node["self"].split("/").last.to_i
    end

    def properties
      NeoActiveGraph.db.get_node_properties @node
    end

  private

    def create *properties
      @node = nil

      if @unique.nil?
        @node = NeoActiveGraph.db.create_node *properties
      else
        @node = NeoActiveGraph.db.create_unique_node @unique[:name], @unique[:key], Hash[*properties][@unique[:key].to_sym], *properties

      end

      NeoActiveGraph.db.set_label @node, @label if @label

      @node
    end

    # def self.properties *attrs
    #   @db.get_node_properties attrs
    # end

    # def self.to_index *attrs
    #   @db.add_node_to_index attrs
    # end
  end
end
