class CreateArticles < ActiveRecord::Migration
  def self.up
    
    add_column :pages, :department_id, :integer
    
    create_table :categories do |t|
      t.column :title, :string
      t.column :slug, :string
      t.column :breadcrumb, :string
    end
    
    create_table :articles_categories, :id => false do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
    end
    
    create_table :departments do |t|
      t.column :title, :string
      t.column :slug, :string
    end
    
    create_table :departments_users, :id => false do |t|
      t.column :department_id, :integer
      t.column :user_id, :integer
    end
    
  end

  def self.down
    drop_table :categories
    drop_table :articles_categories
    drop_table :departments
    drop_table :departments_users
    remove_column :pages, :department_id
  end
end
