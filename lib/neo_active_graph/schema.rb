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

    attr_accessor :label, :unique, :validators, :schema

    def [] property
      self.send "#{property}"
    end

    def []= property, value
      self.send "#{property}=", value
    end

    def initialize properties={}
      @schema = self.class.get_properties || {}

      @unique = self.class.get_unique

      @label = self.class.get_label
      # @validators = self.class.get_validators
      @filters = {
        :before => self.class.before_filters,
        :after => self.class.after_filters
      }
      parse_validators self.class.get_validators || {}
      parse_properties properties if @schema
    end

    def get_properties_from_object
      properties = {}

      @schema.each do |name, value|
        properties.merge! name => self[name]
      end
      properties
    end
    # def define_property

    def parse_properties properties={}
      @schema.each do |attr, value|
        attr = attr.to_sym
        # @properties[attr] = properties[attr] || nil

        self.class.send :attr_accessor, attr
        self.send "#{attr}=", properties[attr] unless properties[attr].nil?
      end
    end
  end
end
