require 'neo_active_graph/schema_class_methods'

module NeoActiveGraph
  class Schema
    include NeoActiveGraph::Validator

    class << self

      include NeoActiveGraph::SchemaClassMethods

      attr_accessor :before_filters, :after_filters
    end

    attr_accessor :label, :unique, :validators, :schema, :errors

    def [] property
      self.send "#{property}"
    end

    def []= property, value
      self.send "#{property}=", value
    end

    def initialize properties={}
      @schema = self.class.get_properties || {}

      @errors ||= {}

      @unique = self.class.get_unique

      @label = self.class.get_label
      # @validators = self.class.get_validators
      @filters = {
        :before => self.class.before_filters,
        :after => self.class.after_filters
      }
      parse_validators self.class.get_validators || {}
      parse_properties properties
    end

    def get_properties_from_object
      properties = {}

      @schema.each do |name, value|
        properties.merge! name => self[name]
      end
      properties
    end
    # def define_property

    def run_filters type
      @filters[type].each do |method|
        self.send(method) if self.respond_to? method
      end if @filters[type]
    end

    def parse_properties properties={}
      list = @schema.merge properties
      list.each do |attr, value|
        attr = attr.to_sym
        # @properties[attr] = properties[attr] || nil
        self.class.send :attr_accessor, attr
        self.send "#{attr}=", properties[attr] unless properties[attr].nil?
      end
    end
  end
end
