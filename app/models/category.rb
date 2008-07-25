class Category < ActiveRecord::Base
  has_many :articles
  # has_and_belongs_to_many :articles
  # has_many :article_categories
  # has_many :articles, :through => :article_categories
  
end
