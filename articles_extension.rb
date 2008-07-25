# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ArticlesExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/articles"
  
  define_routes do |map|
    
    map.resources :articles, :controller => "admin/articles", :path_prefix => "/admin", :name_prefix => "admin_" # Regular routes for comments
    map.article_remove 'admin/articles/remove/:id', :controller => "admin/articles", :action => 'remove'
    
    map.with_options :sector => /(senate|services)/, :category => /(events|articles|proposals|past-proposals|announcements|event-recaps|jobs|volunteer-opportunities|minutes|elections)/ do |article|
      article.department_category "/:sector/:department/:category/:slug", :controller => "articles", :action => "show"
      article.department_category_articles "/:sector/:department/:category/", :controller => "articles", :action => "index"
    end
  end
  
  def activate
    Page.send :include, ArticleTags
    
    admin.tabs.add "Articles", "/admin/articles", :visibility => [:all], :before => "Pages"
    
    User.class_eval do
      has_and_belongs_to_many :departments
      has_many :articles, :foreign_key => "created_by"
    end
    
  end
  
  def deactivate
    admin.tabs.remove "Articles"
  end
  
end