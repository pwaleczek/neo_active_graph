module NeoActiveGraph
  class Schema
    include NeoActiveGraph::Validator

    class << self

      def label name
        @label = name
      end

      def unique name, key
        @unique = { :name => name.to_s, :key => key }
      end

      def property name, options={}
        @properties ||= {}
        @properties.merge! name => nil
        @validators ||= {}
        @validators.merge! name => options
      end

      def before_filter *methods
        @before_filters ||= []
        @before_filters += methods
      end

      def after_filter *methods
        @after_filters ||= []
        @after_filters += methods
      end

      def get_label; @label; end
      def get_unique; @unique; end
      def get_validators; @validators; end
      def get_properties; @properties; end

      attr_accessor :before_filters, :after_filters
    end

    attr_accessor :label, :unique
    attr_reader :validators, :properties

    def initialize properties={}
      # if this is nil then the node has not yet been created in the db
      @node = nil

      @properties = self.class.get_properties

      @unique = self.class.get_unique

      @label = self.class.get_label
      @validators = self.class.get_validators
      @filters = {
        :before => self.class.before_filters,
        :after => self.class.after_filters
      }


      @properties.each do |attr, value|
        attr = attr.to_sym

        @properties[attr] = properties[attr] || nil

        self.class.send(:attr_accessor, attr)
        self.send("#{attr}=", properties[attr])

      end if @properties

    end


    def persisted?
      self.id == 1
    end

  end
end
