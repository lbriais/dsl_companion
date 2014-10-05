module DSLCompanion
  module Features

    module Basic

      include MetaHelper

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