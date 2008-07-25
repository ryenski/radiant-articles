class ArticlesBelongToOneCategory < ActiveRecord::Migration

  def self.up
    add_column :pages, :category_id, :integer
    
    Article.find(:all).each do |article|
      article.update_attribute(:category_id, article.categories.first.id)
      say "article #{article.id} updated successfully. Category_id is #{article.category_id}"
    end
    
    drop_table :articles_categories 
  end
  
  def self.down
    
    create_table :articles_categories, :id => false do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
    end
    
    remove_column :pages, :category_id
    
  end
end