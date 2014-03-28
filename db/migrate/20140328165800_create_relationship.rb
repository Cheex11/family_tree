class CreateRelationship < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.column :person_id, :integer
      t.column :parent_one_id, :integer
      t.column :parent_two_id, :integer
      t.column :spouse_id, :integer
    end
  end
end
