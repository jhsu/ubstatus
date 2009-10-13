class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :api_key
    end
    add_index :users, :api_key
  end

  def self.down
    drop_table :users
  end
end
