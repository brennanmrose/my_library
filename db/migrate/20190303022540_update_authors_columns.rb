class UpdateAuthorsColumns < ActiveRecord::Migration
  def self.down
  	remove_column :authors, :first_name
  end

  def self.down
  	remove_column :authors, :last_name
  end

  def self.up
  	add_column :authors, :name, :string
  end
end
