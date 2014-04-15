module NeoActiveGraph
  module SchemaClassMethods
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

  end
end

