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

    module ExtraModule
      def extra_dsl_command

      end
    end

    interpreter = subject.new :strict
    interpreter.add_feature ExtraModule

    expect(interpreter.respond_to? :extra_dsl_command).to be_truthy
    expect {interpreter.run {extra_dsl_command} }.not_to raise_error
    expect {interpreter.run {unknown_command} }.to raise_error

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


end