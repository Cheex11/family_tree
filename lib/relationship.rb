class Relationship < ActiveRecord::Base
  belongs_to :person

  def self.find_parents(person_id)
    child_relationship = Relationship.find_by(person_id: person_id)

    person = Person.find(child_relationship.person_id)
    mother = Person.find(child_relationship.parent_one_id)
    father = Person.find(child_relationship.parent_two_id)

    [mother.id, father.id]
  end

  def self.find_children(person_id)
    children = []
    parent_relationships = Relationship.where("parent_one_id = ? or parent_two_id = ?", person_id, person_id)
    parent_relationships.each do |relationship|
      children << Person.find(relationship.person_id).id
    end
    children
  end


  def self.find_siblings(person_id)
    person = Relationship.find_by(person_id: person_id)

    siblings = []

    Relationship.all.each do |relationship|
      if relationship.parent_one_id == person.parent_one_id && relationship.parent_two_id == person.parent_two_id && relationship.person_id != person_id.to_i
        siblings << Person.find(relationship.person_id).id
      end
    end
  siblings
  end

  def spouse
    if spouse_id.nil?
      nil
    else
      Relationship.find(spouse_id)
    end
  end
end




