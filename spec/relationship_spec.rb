require 'spec_helper'

describe Relationship do
  it { should belong_to :person }

  describe '.find_grandparents' do
    it "returns a person's grandparents when their ID is entered" do
      test_grandchild = Person.create({:name => 'Patti', :gender => 'female'})
      test_mom = Person.create({:name => 'Jenny', :gender => 'female'})
      test_dad = Person.create({:name => 'Gary', :gender => 'male'})
      test_grandma = Person.create({:name => 'Patsy', :gender => 'female'})
      test_grandpa = Person.create({:name => 'Will', :gender => 'female'})
      test_grandma_pat = Person.create({:name => 'Joan', :gender => 'female'})
      test_grandpa_pat = Person.create({:name => 'Jim', :gender => 'female'})

      test_relationship1 = Relationship.create({ :person_id => test_grandchild.id, :parent_one_id => test_mom.id, :parent_two_id => test_dad.id})
      test_relationship2 = Relationship.create({ :person_id => test_mom.id, :parent_one_id => test_grandma.id, :parent_two_id => test_grandpa.id})
      test_relationship3 = Relationship.create({ :person_id => test_dad.id, :parent_one_id => test_grandma_pat.id, :parent_two_id => test_grandpa_pat.id})

      Relationship.find_grandparents(test_grandchild.id).should eq ['Patsy', 'Will', 'Joan', 'Jim']
    end
  end

  describe '.find_siblings' do
    it 'should return all siblings for a person' do
      test_person = Person.create({:name => 'Luke', :gender => 'male'})
      test_brother = Person.create({:name => 'Owen', :gender => 'male'})
      test_sister = Person.create({:name => 'Jill', :gender => 'male'})
      test_mom = Person.create({:name => 'Laura', :gender => 'male'})
      test_dad = Person.create({:name => 'Tracy', :gender => 'male'})
      test_relationship1 = Relationship.create({ :person_id => test_person.id, :parent_one_id => test_mom.id, :parent_two_id => test_dad.id})
      brother_relationship = Relationship.create({ :person_id => test_brother.id, :parent_one_id => test_mom.id, :parent_two_id => test_dad.id})
      sister_relationship = Relationship.create({ :person_id => test_sister.id, :parent_one_id => test_mom.id, :parent_two_id => test_dad.id})

      Relationship.find_siblings(test_person.id).should eq ['Owen', 'Jill']
    end
  end

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      adam = Person.create({:name => 'Adam', :gender => 'male'})
      steve = Person.create({:name => 'Steve', :gender => 'male'})
      relationship = Relationship.create({:person_id => adam.id, :spouse_id => '' })
      relationship.update(:spouse_id => steve.id)
      adam.relationships[0].spouse_id.should eq steve.id
    end

    it "is nil if they aren't married" do
      eve = Person.create(:name => 'Eve', :gender => 'female')
      eve = Relationship.create(:person_id => eve.id)
      eve.spouse.should be_nil
    end
  end

end
