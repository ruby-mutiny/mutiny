module Mutiny
  module Valuable
    def attributes(*without_defaults, **with_defaults)
      @predefined_attributes ||= {}
      @predefined_attributes = @predefined_attributes.merge(from(without_defaults, with_defaults))
      add_instance_methods(@predefined_attributes)
    end
    
    def specialises(clazz)
      unless clazz.kind_of? Valuable
        raise ArgumentError.new("specialisation requires a class that extends Valuable")
      end
      
      super_attributes = clazz.new.instance_variable_get(:@attributes)
      @predefined_attributes ||= {}
      @predefined_attributes = super_attributes.merge(@predefined_attributes)
      add_instance_methods(@predefined_attributes)
    end
  
  private
    # Converts a list of attribute names and a hash of attribute names to default values
    # to a hash of attribute names to default values
    def from(without_defaults, with_defaults)
      {}.tap do |attributes|
        without_defaults.each { |name| attributes[name] = nil }
        with_defaults.each_pair { |name, default| attributes[name] = default }
      end
    end
    
    def add_instance_methods(predefined_attributes)
      add_constructor(predefined_attributes)
      add_accessors(predefined_attributes.keys)
      add_equality_methods(predefined_attributes.keys)
      add_inspect_method(predefined_attributes.keys)
    end
  
    def add_constructor(predefined_attributes)
      define_method "initialize" do |attributes = {}|
        @attributes = predefined_attributes.merge(attributes)
      end
    end

    def add_accessors(names)
      names.each do |name|
        define_method "#{name}" do
          @attributes[name.to_sym]
        end
      end
    end

    def add_equality_methods(names)
      define_method "eql?" do |other|
        other.is_a?(self.class) &&
        names.all? { |name| other.send(name.to_sym) == self.send(name.to_sym) }
      end
      
      alias_method "==", "eql?"
      
      define_method "hash" do
        @attributes.hash
      end
    end
    
    def add_inspect_method(names)
      define_method "inspect" do
        values = @attributes.keys
          .map { |name| "#{name.to_s}=#{@attributes[name].inspect}" }
          .join(", ")
          
        "<#{self.class.name} #{values}>"
      end
    end
  end
end