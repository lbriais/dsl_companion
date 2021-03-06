module DSLCompanion

  class Interpreter

    include DSLCompanion::Features::Basic

    attr_writer :logger
    attr_reader :current_context

    DEFAULT_EXEC_MODE=:lazy

    def initialize(exec_mode=DEFAULT_EXEC_MODE)
      @interpreter = self
      self.exec_mode = exec_mode
      @current_context = self
    end


    def run(file=nil, &block)
      if file.nil?
        self.instance_eval &block
      else
        @source_code_file = file
        code = File.read file
        self.instance_eval code
      end
    ensure
      @last_source_code_file = @source_code_file
      @source_code_file = nil
    end

    def self.run(file=nil, exec_mode=DEFAULT_EXEC_MODE, &block)
      new(exec_mode).run file, &block
    end


    def exec_mode=(mode)
      if [:strict, true].include? mode
        @exec_mode = :strict
        return @exec_mode
      end
      if [:lazy, false].include? mode
        @exec_mode = :lazy
        return @exec_mode
      end
      raise 'DSL Interpreter: Invalid execution mode !'
    end
    attr_reader :exec_mode


    def exec_strict_mode?
      @exec_mode == :strict
    end

    def add_feature(mod)
      self.meta_eval do
        include mod
      end
    end

    def method_missing(symbolic_name, *args)
      method_name ||= symbolic_name.to_s
      message = "DSL Interpreter: method '#{method_name}'"
      message += block_given? ? ' (with a code block passed).' : ' (with no code block passed)'
      message += ' is unknown'
      message += " within DSL file: '#{@source_code_file}'" unless @source_code_file.nil?
      message += '.'
      logger message, :error unless exec_strict_mode?
      raise message if exec_strict_mode?
    end

  end

end