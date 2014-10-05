module DSLCompanion

  module ContextHelper

    def execute_within_context(context=@context, &block)
      # Execute the block if any
      if block_given?
        last_saved_context = @context
        @context = context
        begin
          # puts ">>>> Switching to context: #{@context} (from #{last_saved_context})"
          @context.send :instance_variable_set, '@interpreter', @interpreter
          @context.instance_eval(&block)
        ensure
          @context = last_saved_context
          # puts "<<<< Back to context: #{@context}"
        end
      end
    end

  end

end