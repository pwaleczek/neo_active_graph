module NeoActiveGraph
  module Validator

    def valid?
      return true unless @properties

      @properties.each do |prop, val|
        return false unless validate prop, val
      end
    end

    def errors
      @errors
    end

    def validate property, value
      @errors ||= []
      checks = @validators[property.to_sym]

      checks.each do |name, method|
        case name
        when :type
          @errors.push "Value type does not match the declared one (#{method})" unless (value.is_a?(method) || (value.nil? && !checks[:presence]))
        when :format
          @errors.push "Format needs to be a regular expression" unless (method.is_a?(Regexp) && !!(value =~ method))
        when :presence

          @errors.push "Value must be present" if value.nil?
        end

      end if checks

      @errors.empty?
    end
  end
end
