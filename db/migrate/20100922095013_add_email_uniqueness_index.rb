class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    #method called add_index that adds an index on the email column of the
    #users table
    add_index :users, :email, :unique=> true
  end

  def self.down
    remove_index :users, :email
  end
end
