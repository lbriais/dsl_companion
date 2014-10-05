module DSLCompanion

  module Injection

    def inject(var_name, target)
      # Inject instance variable in the interpreter context
      injected_accessor = name.to_s.gsub(/^\s+/, '').tr(' ', '_').underscore.to_sym
      injected_instance_variable = "@#{injected_accessor}"
      already_defined = self.instance_variable_defined? injected_instance_variable
      Rails.logger.warn("DSL Interpreter: Overriding existing variable '#{injected_instance_variable}'") if already_defined
      self.instance_variable_set injected_instance_variable, target

      # Defines the method that returns the instance variable and inject into the interpreter's context
      meta_def "#{injected_accessor}" do
        self.instance_variable_get injected_instance_variable
      end
    end

  end

end

