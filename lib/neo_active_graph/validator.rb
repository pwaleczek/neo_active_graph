module NeoActiveGraph
  module Validator

    def valid?
      @errors = nil
      validate
    end

    def errors
      @errors ||= {}
    end

    def get_property_for_validation property
      get_properties_from_object[property]
    end

    def validate_presence property, value
      prop = get_property_for_validation property
      add_error property, "Value must be present" if prop.nil?
    end

    def validate_format property, value
      prop = get_property_for_validation property
      add_error property, "Format needs to be a regular expression" unless (@validators[property][:format].is_a?(Regexp) && !!(value =~ @validators[property][:format]))
    end

    def validate_type property, value
      prop = get_property_for_validation property
      add_error property, "Value type does not match the declared one (#{@validators[property][:type]})" unless value.is_a?(@validators[property][:type])
    end

    def parse_validators list={}
      @validators ||= {}
      list.each do |name, options|
        @validators.merge! name => {} unless options.empty?

        @validators[name][:presence] = true if options[:presence]
        @validators[name][:format] = options[:format] if options[:format] && options[:format].is_a?(Regexp)
        @validators[name][:type] = options[:type] unless options[:type].nil?
      end
    end

    def add_error property, message
      @errors ||= {}
      @errors[property] ||= []
      @errors[property].push message
    end

    def validate
      @errors ||= {}
      get_properties_from_object.each do |prop, val|
        validate_each prop, self[prop.to_sym]
      end
      @errors.empty?
    end

    def validate_each property, value
      @validators[property].each do |name, validation|
        self.send "validate_#{name}", property, value if @validators[property][:presence]
      end
    end
  end
end
