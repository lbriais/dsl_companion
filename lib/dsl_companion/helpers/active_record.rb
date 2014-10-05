module DSLCompanion

  module ActiveRecordAttributesExposer
    def add_dsl_attributes(record)
      extra_module = nil
      record.class.columns.each do |col|
        # Remove the columns we don't want to give direct access to.
        next if col.primary
        next if col.name =~ /_id$/i
        next if col.name =~ /^(created|updated)_at$/i

        # Creating a module to ease the DSL, exposing AR attributes as methods.
        # When in a do block attributes can be directly modified without specifying "self".
        extra_module ||= Module.new
        extra_module.module_eval do
          define_method(col.name.to_sym) do |arg=nil|
            if arg.nil?
              self[col.name]
            else
              self[col.name] = arg
            end
          end
        end
      end

      # And then include the module into the instance if needed
      record.extend extra_module unless extra_module.nil?
    end
  end
end
