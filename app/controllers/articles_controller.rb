class ArticlesController < SiteController
  # Remove this line if your controller should only be accessible to users
  # that are logged in:
  no_login_required

  def index
    department = Department.find_by_slug(params[:department])
    redirect_to "/#{department.sector.slug}/#{params[:department]}##{params[:category]}"
  end
  
  def show
    response.headers.delete('Cache-Control')
    url = "/#{params[:sector].to_s}/#{params[:department].to_s}/#{params[:category]}/#{params[:slug].to_s}"
    
    if (request.get? || request.head?) and (@cache.response_cached?(url))
      @cache.update_response(url, response, request)
      @performed_render = true
    else
      show_uncached_page(url)
    end
  end
  
  def show_uncached_page(url)
    @department = Department.find_by_slug(params[:department])
    @article = @department.articles.find_by_id(params[:slug].to_i)
    unless @article.nil?
      process_page(@article)
      @cache.cache_response(url, response) if request.get? and live? and @article.cache?
      @performed_render = true
    else
      render :template => 'site/not_found', :status => 404
    end
  rescue Page::MissingRootPageError
    redirect_to welcome_url
  end
  
  
end
