class Relationship < ActiveRecord::Base
  belongs_to :person

  def self.find_grandparents(grandchild_id)
    grandchild_relationship = Relationship.find_by(person_id: grandchild_id)
    mother_relationship = Relationship.find_by(person_id: grandchild_relationship.parent_one_id)
    father_relationship = Relationship.find_by(person_id: grandchild_relationship.parent_two_id)
    results = []
    results << Person.find(mother_relationship.parent_one_id).name
    results << Person.find(mother_relationship.parent_two_id).name
    results << Person.find(father_relationship.parent_one_id).name
    results << Person.find(father_relationship.parent_two_id).name
    results
  end

  def self.find_siblings(person_id)
    person = Relationship.find_by(person_id: person_id)

    results = []

    Relationship.all.each do |relationship|
      if relationship.parent_one_id == person.parent_one_id && relationship.parent_two_id == person.parent_two_id && relationship.person_id != person_id.to_i
        results << Person.find(relationship.person_id).name
      end
    end
  results
  end

  def spouse
    if spouse_id.nil?
      nil
    else
      Relationship.find(spouse_id)
    end
  end
end
