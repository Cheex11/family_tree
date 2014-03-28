require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press r to add relationship'
    puts 'Press v to view a persons relationships'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press x to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'r'
      add_relationship
    when 'v'
      view_relationships
    when 'l'
      list
    when 'm'
      add_marriage
    when 'x'
      exit
    end
  end
end


def add_marriage
  list
  puts "Please select the ID of the person who got married?"
  relationship = Relationship.find_by(person_id: gets.chomp)

  puts "Please select the ID of the person they married"
  new_spouse = Person.find(gets.chomp.to_i)


  relationship.update(:spouse_id => new_spouse.id)
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  puts "Is #{name} male or female?"
  gender = gets.chomp
  Person.create(:name => name, :gender => gender)
  puts name + " was added to the family tree.\n\n"
end

def add_relationship
  list
  puts "Please select the ID of the person you would like to add relationships to:"
  person = Person.find(gets.chomp.to_i)

  puts "Please select the ID of #{person.name}'s mother:"
  mother = Person.find(gets.chomp.to_i)
  puts "Please select the ID of #{person.name}'s father:"
  father = Person.find(gets.chomp.to_i)
  puts "Please enter the ID of #{person.name}'s spouse if they have one:"
  spouse = gets.chomp
  if spouse != ''
    spouse = Person.find(spouse.to_i).id
  end

  Relationship.create({ :person_id => person.id,
                        :parent_one_id => mother.id,
                        :parent_two_id => father.id,
                        :spouse_id => spouse})

  puts "#{person.name}'s relationships have been created!\n\n"
end

def view_relationships
  list
  puts "Please select the ID of the person you would like to view relationships for:"
  person_id = gets.chomp.to_i

  loop do
    puts "Press '1' to view their spouse"
    puts "Press '2' to view their parents"
    puts "Press '3' to view their children."
    puts "Press '4' to view their siblings"
    puts "Press '5' to view their grandparents"
    puts "Press '6' to view their grandchildren"
    puts "Press '7' to view their aunt and uncle"

    puts "Press 'm' to return to the main menu"
    user_choice = gets.chomp

    case user_choice
      when '1' then view_spouse(person_id)
      when '2' then view_parents(person_id)
      when '3' then view_children(person_id)
      when '4' then view_siblings(person_id)
      when '5' then view_grandparents(person_id)
      when '6' then view_grandchildren(person_id)
      when '7' then view_auntanduncle(person_id)

      when 'm' then menu
      else puts "please enter a valid option"
    end
  end
end

def view_parents(person_id)
  # Relationship.find_parents(person_id).each { |parent| puts "#{Person.find(parent).name}" }
  person = Person.find(person_id)
  parents = Relationship.find_parents(person_id)
  puts "#{Person.find(parents[0]).name} is #{person.name}'s mom and #{Person.find(parents[1]).name} is #{person.name}'s dad"
  puts "\n\n"
end

def view_children(person_id) #Add if statement later for people with no children.
  person = Person.find(person_id)
  Relationship.find_children(person_id).each do |child|
    if Person.find(child).gender == 'male'
      puts "#{Person.find(child).name} is #{person.name}'s son"
    else
      puts "#{Person.find(child).name} is #{person.name}'s daughter"
    end
  end
  puts "\n\n"
end

def view_siblings(person_id)
  person = Person.find(person_id)
  Relationship.find_siblings(person_id).each do |sibling|
    if Person.find(sibling).gender == 'male'
      puts "#{Person.find(sibling).name} is #{person.name}'s brother"
    else
      puts "#{Person.find(sibling).name} is #{person.name}'s sister"
    end
  end
  puts "\n\n"
end

def view_grandparents(person_id)  #add paternal/maternal later
  person = Person.find(person_id)
  Relationship.find_parents(person_id).each do |parent|
    Relationship.find_parents(parent).each do |grandparent|
      if Person.find(grandparent).gender == 'male'
        puts "#{Person.find(grandparent).name} is #{person.name}'s grandpa"
      else
        puts "#{Person.find(grandparent).name} is #{person.name}'s grandma"
      end
    end
  end
  puts "\n\n"
end

def view_grandchildren(person_id)
  person = Person.find(person_id)
  Relationship.find_children(person_id).each do |child|
    Relationship.find_children(child).each do |grandchild|
      if Person.find(grandchild).gender == 'male'
        puts "#{Person.find(grandchild).name} is #{person.name}'s grandson"
      else
        puts "#{Person.find(grandchild).name} is #{person.name}'s granddaughter"
      end
    end
  end
  puts "\n\n"
end

def view_auntanduncle(person_id) # refactor, make DRY
  person = Person.find(person_id)
  Relationship.find_parents(person_id).each do |parent|
    Relationship.find_siblings(parent).each do |sibling|
      sibling_spouse = Relationship.find_by(person_id: sibling).spouse_id
      if Person.find(sibling).gender == 'male'
        puts "#{Person.find(sibling).name} is #{person.name}'s Uncle"
      end
      if Person.find(sibling_spouse).gender == 'male'
        puts "#{Person.find(sibling_spouse).name} is #{person.name}'s Uncle"
      end
      if Person.find(sibling_spouse).gender == 'female'
        puts "#{Person.find(sibling_spouse).name} is #{person.name}'s Aunt"
      end
      if Person.find(sibling).gender == 'female'
        puts "#{Person.find(sibling).name} is #{person.name}'s Aunt"
      end
    end
  end
  puts "\n\n"
end

def view_spouse(person_id)
  relationship = Relationship.find_by(person_id: person_id)

  person = Person.find(relationship.person_id)
  spouse = Person.find(relationship.spouse_id)

  puts "#{spouse.name} is #{person.name}'s spouse.\n\n"
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

menu
