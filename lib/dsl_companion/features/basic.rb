module DSLCompanion
  module Features

    module Basic

      include DSLCompanion::MetaHelper

      # If any method named define_<something>(*args) is in the DSL, then it provides an alternate
      # generic syntax of define(:something, *args)
      # @param [Object[]] args
      # @param [Proc] block
      # @return [Anything returned by the method]
      def define(*args, &block)
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
          last_saved_context = @current_context
          @current_context = context
          begin
            logger "Switching to context: #{@current_context} (from #{last_saved_context})"
            MetaHelper.inject_variable @current_context, :interpreter, @interpreter
            @current_context.instance_eval(&block)
          ensure
            @current_context = last_saved_context
            logger "Back to context: #{@current_context}"
          end
        end
      end

      def interpreter?
        self.is_a? DSLCompanion::Interpreter
      end

      def interpreter
        self if interpreter?
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