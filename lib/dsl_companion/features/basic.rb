module DSLCompanion
  module Features

    module Basic

      # If any method named define_<something>(*args) is in the DSL, then it provides an alternate
      # generic syntax of define(:something, *args)
      # @param [Object[]] args
      # @param [Proc] block
      # @return [Anything returned by th emethod]
      def define *args, &block
        extra = args.shift
        method_name = "define_#{extra}"
        if respond_to? method_name.to_sym
          block_given? ? self.send(method_name, *args, &block) : self.send(method_name, *args)
        else
          block_given? ? method_missing(method_name.to_sym, *args, & block) : method_missing(method_name.to_sym, *args)
        end
      end

      def interpreter?
        self.is_a? DSLHelper::Interpreter
      end

      def interpreter
        self
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

      def logger(msg, level=:info)
        if @logger.nil?
          STDERR.puts "#{level.to_s.upcase}: #{msg}"
        else
          @logger.send level, msg
        end
      end


    end

  end
end