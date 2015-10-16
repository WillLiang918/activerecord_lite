class AttrAccessorObject
  def self.my_attr_accessor(*names)

    my_attr_reader(*names)
    my_attr_writer(*names)
  end
    # ...
  def self.my_attr_reader(*attrs)
    attrs.each do |attr|
      define_method(attr) do
        instance_variable_get("@#{attr}")
      end
    end
  end

  def self.my_attr_writer(*attrs)
    attrs.each do |attr|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value)
      end
    end
  end
end
