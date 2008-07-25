class AddFeatureOptions < ActiveRecord::Migration

  def self.up
    add_column :pages, :feature, :boolean
    add_column :pages, :feature_position, :integer
  end
  
  def self.down
    remove_column :pages, :feature
    remove_column :pages, :feature_position
  end
end