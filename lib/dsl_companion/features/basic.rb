module DSLCompanion
  module Features

    module Basic

      include MetaHelper

      # If any method named define_<something>(*args) is in the DSL, then it provides an alternate
      # generic syntax of define(:something, *args)
      # @param [Object[]] args
      # @param [Proc] block
      # @return [Anything returned by the method]
      def define *args, &block
        extra = args.shift
        method_name = "define_#{extra}"
        if respond_to? method_name.to_sym
          block_given? ? self.send(method_name, *args, &block) : self.send(method_name, *args)
        else
          block_given? ? method_missing(method_name.to_sym, *args, &block) : method_missing(method_name.to_sym, *args)
        end
      end

      def execute_within_context(context=@context, &block)
        # Execute the block if any
        if block_given?
          last_saved_context = @context
          @context = context
          begin
            logger "Switching to context: #{@context} (from #{last_saved_context})"
            @context.send :instance_variable_set, '@interpreter', @interpreter
            @context.instance_eval(&block)
          ensure
            @context = last_saved_context
            logger "Back to context: #{@context}"
          end
        end
      end

      def interpreter?
        self.is_a? DSLHelper::Interpreter
      end

      def interpreter
        self
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