module NeoActiveGraph
  module Query

    class << self

      def execute params={}
        query = nil

        if !params.is_a?(String) && block_given?
          query = Neo4j::Cypher.query(params, &Proc.new)
        else
          query = params
        end

        NeoActiveGraph.db.execute_query query
      end

      alias_method :exec, :execute
    end
  end
end
