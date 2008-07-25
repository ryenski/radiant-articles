Page.class_eval do
  validates_uniqueness_of :slug, :if => :do_slug_validation, :message => "is slimey"
  
  def do_slug_validation
    false
  end
  
end


class Article < Page
  belongs_to :department
  belongs_to :category
  belongs_to :user, :foreign_key => "created_by"
  
  validates_presence_of :title, :category, :department
  # validates_uniqueness_of :slug, :scope => :department_id, :message => 'is already in use for ths department'
  
  def url
    "/#{department.sector.slug rescue "no sector"}/#{department.slug rescue "no dept"}/#{category.slug rescue "no category"}/#{slug}"
  end
  
  def slug
    "#{id}-#{super}"
  end
  
  def date_published
    published_at ? published_at : created_at
  end
  
  def layout
    Layout.find_by_name("Articles")
  end
  
  def new_breadcrumb
    [department.slug, category.slug, breadcrumb].join(", ")
  end
  
  def self.new_with_defaults(params=nil)
    config = Radiant::Config
    default_parts = ["Excerpt", "Content", "Video"]
    page = new(params)
    default_parts.each do |name|
      page.parts << PagePart.new(:name => name)
    end
    default_status = config['defaults.page.status']
    page.status = Status[default_status] if default_status
    page
  end
  
  def self.find_recent(*args)
    self.find(:all, :order => "published_at DESC, created_at DESC", :conditions => (args.first[:conditions] if args.first))
  end
  
end
