require 'spec_helper'

describe DSLCompanion::Interpreter do

  subject{DSLCompanion::Interpreter}

  it 'should be used with a block of commands' do
    the_class=nil
    subject.run do
      the_class = self.class
    end
    expect(the_class == DSLCompanion::Interpreter).to be_truthy
  end

  it 'should allow to add extra features through modules' do
    module ExtraFeatureModule
      def extra_dsl_command

      end
    end

    interpreter = subject.new :strict
    interpreter.add_feature ExtraFeatureModule

    expect(interpreter.respond_to? :extra_dsl_command).to be_truthy
    expect {interpreter.run {extra_dsl_command} }.not_to raise_error
    expect {interpreter.run {unknown_command} }.to raise_error
  end

  it 'should give access to some convenience methods' do
    interpreter = subject.new
    expect(interpreter.respond_to? :define).to be_truthy
    expect(interpreter.respond_to? :interpreter).to be_truthy
    expect(interpreter.respond_to? :interpreter?).to be_truthy
  end

  it 'should give the same result for define_<something>(*args) and define(:something, *args)' do

    module ExtraFeatureModule
      def define_stuff(stuff_name, value)
        interpreter.inject_variable stuff_name, value
      end
    end
    interpreter = subject.new :strict
    interpreter.add_feature ExtraFeatureModule
    a,b = nil,nil

    interpreter.run do
      define_stuff :foo, 'Foo Bar'
      a = foo
      define :stuff, :bar, 'Foo Bar'
      b = bar
    end

    expect(a == b).to be_truthy

  end




  it 'should be able to inject new variables in interpreter' do

    module ExtraFeatureModule
      def define_stuff(stuff_name, value)
        interpreter.inject_variable stuff_name, value
      end
    end

    interpreter = subject.new :strict
    interpreter.add_feature ExtraFeatureModule

    interpreter.run do
      define_stuff :pipo, 'Hello world'
    end
    expect {interpreter.run {typo == 'Hello world'} }.to raise_error
    expect {interpreter.run {pipo == 'Hello world'} }.not_to raise_error

  end




  context 'when in lazy mode' do

    it 'should only report through logging errors in the DSL' do
      interpreter = subject.new
      expect {interpreter.run {unknown_command} }.not_to raise_error
    end

  end

  context 'when in strict mode' do

    it 'should raise exceptions if errors in the DSL'do
      interpreter = subject.new :strict
      expect {interpreter.run {unknown_command} }.to raise_error
    end

  end

  it 'should support interpreting code as a string'

  it 'should provide an interactive mode'


end