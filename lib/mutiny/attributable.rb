module Mutiny
  module Attributable
    def attributes(*names)
      add_constructor(names)
      add_accessors(names)
      add_equality_method(names)
    end
  
  private
    def add_constructor(names)
      define_method "initialize" do |attributes|
        @attributes = attributes
      end
    end

    def add_accessors(names)
      names.each do |name|
        define_method "#{name}" do
          @attributes[name.to_sym]
        end
      end
    end

    def add_equality_method(names)
      define_method "==" do |other|
        other.is_a?(self.class) &&
        names.all? { |name| other.send(name.to_sym) == self.send(name.to_sym) }
      end
    end
  end
end