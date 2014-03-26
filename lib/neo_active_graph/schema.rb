require 'neo_active_graph/validator'

module NeoActiveGraph
  class Schema
    include NeoActiveGraph::Validator

    class << self

      # @label = nil
      # @unique = nil
      # @before_filters = nil

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

    def label; @label; end
    def unique; @unique; end
    def validators; @validators; end
    def properties; @properties; end

    def initialize properties={}

      @properties = self.class.get_properties

      @unique = self.class.get_unique

      @label = self.class.get_label
      @validators = self.class.get_validators

      @properties.each do |attr, value|
        # return unless validate attr, value
        @properties[attr] = properties[attr] unless validate attr, value
        # @properties.merge! attr => value

        self.class.send(:attr_accessor, attr)
        self.send("#{attr}=", value)

      end if @properties

      self.class.before_filters.each do |method|
        method unless self.respond_to?(method)
      end unless self.class.before_filters.nil?

    end

  end
end
