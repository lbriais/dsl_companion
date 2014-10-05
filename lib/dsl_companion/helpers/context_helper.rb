module DSLCompanion

  module ContextHelper


    # def with_dictionary &block
    #   @within_dictionary = true
    #
    #   raise "'with_dictionary' cannot be processed in this context !" unless interpreter?
    #   execute_within_context @context, &block
    # ensure
    #   @within_dictionary = false
    # end


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




    #  def within_dictionary?
    #    if interpreter?
    #      @within_dictionary
    #    else
    #      @interpreter.within_dictionary?
    #    end
    # end

    # 


    # def interpreter_exec_mode mode=nil
    #   if mode.nil?
    #     @interpreter.exec_mode
    #   else
    #     @interpreter.exec_mode = mode
    #   end
    # end


  end

end