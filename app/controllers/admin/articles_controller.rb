class Admin::ArticlesController < Admin::AbstractModelController
  
  before_filter :get_categories, :only => [:edit, :new]
  
  @@urls_to_expire = [
    "/happenings"
    ]
  
  def index
    conditions = {}
    conditions[:category_id] = params[:category_id] if params[:category_id]
    conditions[:department_id] = params[:department_id] if params[:department_id]
    @pages = Article.find(:all, :order => "published_at DESC, created_at DESC", :conditions => (conditions unless conditions.empty?))
  end
  
  def new
    @page = Article.new_with_defaults(params[:page])
  end
  
  def create
    @page = Article.new(params[:page])
    
    if @page.save and update_parts
      cache.clear
      flash[:notice] = "Article Saved"
      redirect_to :action => :index
    else
      flash[:error] = "Validation errors occurred while saving this article. Please take a moment to review the form and correct any input errors before continuing. #{@page.errors.full_messages.join(", ")}"
      render :action => :new
    end
  end
  
  def edit
    @page = Article.find(params[:id])
  end
  
  def update_parts
    parts = @page.parts
    parts_to_update = {}
    (params[:part]||{}).each {|k,v| parts_to_update[v[:name]] = v }
    
    parts_to_remove = []
    @page.parts.each do |part|
      if(attrs = parts_to_update.delete(part.name))
        part.attributes = part.attributes.merge(attrs)
      else
        parts_to_remove << part
      end
    end
    parts_to_update.values.each do |attrs|
      @page.parts.build(attrs)
    end
    if result = @page.save
      new_parts = @page.parts - parts_to_remove
      new_parts.each { |part| part.save }
      @page.parts = new_parts
    end
    result
  end
  
  
  def update
    @page = Article.find(params[:id])
    
    if @page.update_attributes(params[:page]) and update_parts
      cache.clear
      flash[:notice] = "Article Saved"
      redirect_to :action => :index
    else
      flash[:error] = "Validation errors occurred while saving this article. Please take a moment to review the form and correct any input errors before continuing."
      render :action => :new
    end
      
  end
  
  def attach_wymeditor
    ['/wymeditor/jquery/jquery', '/wymeditor/wymeditor/lang/en.js',
    	'/wymeditor/wymeditor/jquery.wymeditor.js', 
    	'/wymeditor/wymeditor/jquery.wymeditor.explorer.js', 
    	'/wymeditor/wymeditor/jquery.wymeditor.mozilla.js', 
    	'/wymeditor/wymeditor/jquery.wymeditor.opera.js',
    	'/wymeditor/wymeditor/jquery.wymeditor.safari.js',
    	'/wymeditor/wymeditor/plugins/hovertools/jquery.wymeditor.hovertools.js', 
    	'/wymeditor/wymeditor/plugins/tidy/jquery.wymeditor.tidy.js',
    	'/wymeditor/wymeditor/xhtml_parser.js', '/javascripts/radiant.wymeditor.js'].each {|script| @javascripts << script}
      @stylesheets << '/wymeditor/wymeditor/skins/default/screen.css'
  end
  
  def remove
    @page = Page.find(params[:id])
    if request.post?
      @page.destroy
      redirect_to admin_articles_url
    end
  end
  
  def get_categories
    @categories = Category.find(:all, :order => "title ASC")
    @departments = Department.find(:all, :order => "title ASC")
  end
  
  def clear_model_cache
    cache.clear
    # cache.expire_response(@page.url)
    # cache.expire_response("/")
  end
  
end
