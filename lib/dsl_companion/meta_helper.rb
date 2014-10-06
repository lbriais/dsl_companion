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
    MetaHelper.inject_variable self, name, value
  end

  def self.inject_variable(target, name, value)
    # Inject instance variable in the target context
    injected_accessor = name.to_s.to_sym
    injected_instance_variable = "@#{injected_accessor}"
    already_defined = target.instance_variable_defined? injected_instance_variable
    logger("DSL Interpreter overriding existing variable '#{injected_instance_variable}'", :warn) if already_defined
    target.extend MetaHelper
    target.instance_variable_set injected_instance_variable, value

    # Defines the method that returns the instance variable and inject into the interpreter's context
    target.meta_def "#{injected_accessor}" do
      target.instance_variable_get injected_instance_variable
    end

  end

end