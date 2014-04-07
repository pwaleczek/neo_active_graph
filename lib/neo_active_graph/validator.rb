module NeoActiveGraph
  module Validator

    def valid?
      @errors = nil
      validate
    end

    def errors
      @errors
    end

    def get_property_for_validation property
      @properties[property]
    end

    def validate_presence property, value
      prop = get_property_for_validation property
      @errors.push "Value must be present" if prop.nil?
    end

    def validate_format property, value
      prop = get_property_for_validation property
      @errors.push "Format needs to be a regular expression" unless (@validators[property][:format].is_a?(Regexp) && !!(value =~ @validators[property][:format]))
    end

    def validate_type property, value
      prop = get_property_for_validation property
      @errors.push "#{property}: Value type does not match the declared one (#{@validators[property][:type]})" unless value.is_a?(@validators[property][:type])
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

    def validate
      return true unless @properties

      @properties.each do |prop, val|
        return false unless validate_each prop, val
      end
      true
    end

    def validate_each property, value
      @errors ||= []
      @validators[property].each do |name, validation|
        self.send "validate_#{name}", property, value if @validators[property][:presence]
      end
      @errors.empty?
    end
  end
end
