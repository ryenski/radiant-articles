module ArticleTags
  include Radiant::Taggable
  
  desc ""
  
  desc %{
    Renders articles. 
    
    <r:articles department="emmerson" />
    <r:article slug="my-article" department="emmerson" />
    
    <r:articles:each department="emmerson">
    
    </r:articles:each>
    
  }
  tag "articles" do |tag|
    # find article in the department
    # 
    tag.expand
  end
  
  # Add feature "There are currently no proposals in Hope North. View all proposals. "
  desc %{
    Cycles through each article and renders the enclosed tags for each. 
  }
  tag "articles:each" do |tag|
    department = if tag.attr['department'] == "auto"
      if tag.locals.page.respond_to?(:department)
        Department.find_by_slug(tag.locals.page.department.slug)
      else
        Department.find_by_slug(tag.locals.page.slug)
      end
    else
      Department.find_by_slug(tag.attr['department'])
    end
    
    category = if tag.attr['category'] == "auto"
      Category.find_by_slug(tag.locals.page.category.slug)
    else
      Category.find_by_slug(tag.attr['category'])
    end
    # category = Category.find_by_slug(tag.attr['category'])
    
    limit = tag.attr['limit'] if tag.attr['limit']
    
    conditions = ["status_id = 100"]
    conditions << "category_id = #{category.id}" if category
    conditions << "department_id = #{department.id}" if department
    conditions << "event_start_date > '#{Time.now.at_midnight.to_s(:db)}'" if tag.attr['context'] and tag.attr['context'] == "future"
    conditions << "event_start_date < '#{Time.now.at_midnight.to_s(:db)}'" if tag.attr['context'] and tag.attr['context'] == "past"
    conditions = conditions.compact.join(" AND ")
    
    order = tag.attr['order'] ? tag.attr['order'] : "published_at DESC, created_at DESC"
    
    articles = Article.find(:all, :order => "#{order}", :conditions => conditions, :limit => limit)
    
    result = []
    articles.each do |article|
      tag.locals.page = article
      result << tag.expand
    end unless articles.empty?
    result
  end
  
  tag "articles:featured" do |tag|
    tag.expand
  end
  
  tag "articles:featured:random" do |tag|
    articles = Article.find(:all, :conditions => {:feature => true, :status_id => "100"})
    tag.locals.page = articles[rand(articles.size)]
    tag.expand
  end
  
  tag "articles:featured:first" do |tag|
    order = tag.attr['order'] ? tag.attr['order'] : "feature_position ASC, event_start_date ASC, created_at DESC"
    article = Article.find(:first, :order => order, :conditions => {:feature => true, :status_id => "100"})
    tag.locals.page = article
    tag.expand
  end
  
  tag "articles:featured:each" do |tag|
    order = tag.attr['order'] ? tag.attr['order'] : "feature_position ASC, event_start_date ASC, created_at DESC"
    conditions = {:feature => true, :status_id => "100"}
    limit = 10
    articles = Article.find(:all, :order => "#{order}", :conditions => conditions, :limit => limit)
    result = []
    articles.each do |article|
      tag.locals.page = article
      result << tag.expand
    end unless articles.empty?
    result
  end
  
  desc %{
    Renders the date a article was created. 
    
    *Usage:* 
    <pre><code><r:date [format="%A, %B %d, %Y"] /></code></pre>
  }
  tag 'date' do |tag|
    article = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    date = article.date_published
    date.strftime(format)
  end
  
  desc %{
    Renders the published date
    
    *Usage:* 
    <pre><code><r:published_date [format="%A, %B %d, %Y"] /></code></pre>
  }
  tag 'published_date' do |tag|
    article = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    date = article.published_at
    date.strftime(format) rescue ""
  end
  
  
  desc %{
    Renders the start date
    
    *Usage:* 
    <pre><code><r:date [format="%A, %B %d, %Y"] /></code></pre>
  }
  tag 'event_start_date' do |tag|
    article = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    date = article.event_start_date
    date.strftime(format) rescue ""
  end
  
  tag 'articles:each:title' do |tag|
    article = tag.locals.page
    article.title
  end
  
  tag 'articles:each:url' do |tag|
    article = tag.locals.page
    article.url
  end
  
  tag 'articles:each:excerpt' do |tag|
    article = tag.locals.page
    article.parts.detect{|p|p.name == "Excerpt"}.content
  end
  
  tag 'articles:each:category' do |tag|
    article = tag.locals.page
    article.category.title
  end
  
  tag 'articles:each:link' do |tag|
    options = tag.attr.dup
    anchor = options['anchor'] ? "##{options.delete('anchor')}" : ''
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : tag.render('title')
    %{<a href="#{tag.render('url')}#{anchor}"#{attributes}>#{text}</a>}
  end
  
  tag 'article_breadcrumbs' do |tag|
    page = tag.locals.page
    breadcrumbs = [page.breadcrumb]
    breadcrumbs.unshift %{<a href="/#{page.department.sector.slug}/#{page.department.slug}##{page.category.slug}">#{page.category.title}</a>}
    breadcrumbs.unshift %{<a href="/#{page.department.sector.slug}/#{page.department.slug}">#{page.department.title}</a>}
    breadcrumbs.unshift %{<a href="/#{page.department.sector.slug}/">#{page.department.sector.title}</a>}
    
    separator = tag.attr['separator'] || ' &gt; '
    breadcrumbs.join(separator)
  end
  
  
  tag 'department' do |tag|
    tag.expand
  end
  
  tag 'department:title' do |tag|
    page = tag.locals.page
    page.department.title
  end
  
  tag 'department:slug' do |tag|
    page = tag.locals.page
    page.department.slug
  end
  
  
  tag 'category' do |tag|
    tag.locals.category = tag.locals.page.category
    tag.expand
  end
  
  tag 'category:title' do |tag|
    page = tag.locals.page
    page.category.title
  end
  
  tag 'category:slug' do |tag|
    page = tag.locals.page
    page.category.slug
  end
  
  tag 'category:pages' do |tag|
    # tag.locals.pages = tag.locals.category.pages
    tag.expand
  end
  
  tag 'category:pages:each' do |tag|
    result = []
    tag.locals.category.articles.each do |page|
      tag.locals.page = page
      result << tag.expand
    end
    result
  end
  
  tag 'category:pages:each:link' do |tag|
    page = tag.locals.page
    %{<a href="#{page.url}" title="#{page.description}">#{page.title}</a>}
  end
  
end