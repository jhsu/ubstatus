class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string  :url, :null => false
      t.integer :status
    end
  end

  def self.down
    drop_table :sites
  end
end
