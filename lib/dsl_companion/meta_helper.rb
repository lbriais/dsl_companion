module MetaHelper

  def metaclass
    class << self
      self
    end
  end

  def meta_eval &block
    metaclass.instance_eval &block
  end

  # Adds method to metaclass
  def meta_def( name, &block )
    meta_eval { define_method name, &block }
  end

  # Defines an instance method within a class
  def class_def( name, &block )
    class_eval { define_method name, &block }
  end

  def inject_variable(name, value)
    # Inject instance variable in the current context
    injected_accessor = name.to_s.to_sym
    injected_instance_variable = "@#{injected_accessor}"
    already_defined = self.instance_variable_defined? injected_instance_variable
    logger("DSL Interpreter overriding existing variable '#{injected_instance_variable}'", :warn) if already_defined
    self.instance_variable_set injected_instance_variable, value

    # Defines the method that returns the instance variable and inject into the interpreter's context
    meta_def "#{injected_accessor}" do
      self.instance_variable_get injected_instance_variable
    end

  end

end