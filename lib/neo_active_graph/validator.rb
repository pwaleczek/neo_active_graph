module NeoActiveGraph
  module Validator

    def valid?
      return true unless @properties

      @properties.each do |prop, val|
        return unless validate prop, val
      end
    end

    def errors
      @errors
    end

    def validate property, value
      @errors ||= []
      checks = @validators[property.to_sym]
      ret_val = false

      checks.each do |name, method|

        case name
        when :type
          t = value.is_a?(method)
          @errors.push "Value type does not match the declared one" unless t
          ret_val = t
        when :format
          @errors.push "Format needs to be a regular expression" unless method.is_a?(Regexp)
          ret_val = !!(value =~ method)
        when :presence
          t = !(value.nil? || value.empty?)
          @errors.push "Value must be present" unless t
          ret_val = t
        end

      end unless checks.nil?

      ret_val
    end
  end
end
