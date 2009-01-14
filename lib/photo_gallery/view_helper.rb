module PhotoGallery::ViewHelper
  def path_links
    set = []
    @parent_id = @gallery.id if @gallery
    set.push([link_to("Create new gallery", :controller => '/photo_gallery/admin/galleries', :action => 'new', :parent_id => @parent_id)]) if @admin
    if !@photo.nil?
      # Use photo
      set += gallery_path_links(@photo.gallery)
      set << @photo.caption
    elsif !@gallery.nil?
      # Use Gallery
      set += gallery_path_links(@gallery)
    end

    str = set.join(" &gt; ")

    "<h2 class='path_links'>#{str}</h2>"
  end

  def content_id(menu)
    menu ? "content" : "wide_content"
  end

  def image_url(photo, opts = {})
    opts = {:size => :thumb}.merge opts
    if photo.nil?
      PhotoGallery.default_image
    else
      photo.image.url(opts[:size])
    end
  end

  def photo_thumb(photo)
    return "" if photo.nil?
    raise("You must save the photo photo before linking to it by calling: #photo.save") if photo.new_record?
    render :partial => 'shared/rounded_thumb', :locals => {:with_delete => true, :path => path_for({:controller => 'photos', :action => 'show', :id => photo})}, :object => photo
  end

  def gallery_thumb(gallery)
    return "" if gallery.nil?
    raise("You must save the photo gallery before linking to it by calling: my_model.gallery.save") if gallery.new_record?
    render :partial => 'shared/rounded_thumb', :locals => {:with_delete => true, :text => gallery.name, :path => path_for({:action => 'show', :controller => 'galleries', :id => gallery}), :gallery => true}, :object => gallery.main_photo
  end

  private
  def path_for(path)
    path.merge({:controller => "/photo_gallery#{@admin ? "/admin" : ""}/#{path[:controller]}"})
  end

  def gallery_path_links(gallery)
    galleries = gallery_hierarchy(gallery)
    galleries.map {|g| link_to(h(g.name), :controller => 'galleries', :action => 'show', :id => g)}
  end

  def gallery_hierarchy(gallery)
    galleries = [gallery]
    until gallery.parent_id.nil?
      gallery = gallery.parent
      galleries.unshift gallery
    end
    galleries
  end
end
