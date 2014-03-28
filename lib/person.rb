class Person < ActiveRecord::Base
  validates :name, :presence => true
  validates :gender, :presence => true
  has_many :relationships


end



# after_save :make_marriage_reciprocal

#   def spouse
#     if spouse_id.nil?
#       nil
#     else
#       Person.find(spouse_id)
#     end
#   end

# private

#   def make_marriage_reciprocal
#     if spouse_id_changed?
#       spouse.update(:spouse_id => id)
#     end
#   end
