require 'spec_helper'

describe DSLHelper::Interpreter do

  it 'should be used with a block of commans' do
    the_class=nil
    subject.run do
      the_class = self.class
    end
    expect(the_class == DSLHelper::Interpreter).to be_truthy
  end

  it 'should allow to add extra features'


end