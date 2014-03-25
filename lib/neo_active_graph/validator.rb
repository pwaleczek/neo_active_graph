module NeoActiveGraph
  module Validator

    def validate property, value

      checks = @validators[property.to_sym]
      ret_val = false

      checks.each do |name, method|

        case name
        when :type
          t = value.is_a?(method)
          raise TypeError, "Value type does not match the declared one" unless t
          ret_val = t
        when :format
          raise TypeError, "Format needs to be a regular expression" unless method.is_a?(Regexp)
          ret_val = !!(value =~ method)
        when :presence
          t = !(value.nil? || value.empty?)
          raise TypeError, "Value must be present" unless t
          ret_val = t
        end

      end unless checks.nil?

      ret_val
    end
  end
end
