require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }
  it { should validate_presence_of :gender }

  it { should have_many :relationships }

  it 'should be initialized with a name and gender' do
    earl = Person.create(:name => 'Earl', :gender => 'male')
    Person.all.should eq [earl]
  end

end
