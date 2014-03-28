class Person < ActiveRecord::Base
  validates :name, :presence => true
  validates :gender, :presence => true
  has_many :relationships


end

