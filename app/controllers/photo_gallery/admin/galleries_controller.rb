class PhotoGallery::Admin::GalleriesController < ::PhotoGallery::GalleriesController

  before_filter do |controller| 
    controller.instance_eval { @admin = PhotoGallery.admin? }
  end

  def new
    @gallery = PhotoGallery::Gallery.new(:parent_id => params[:parent_id])
    @return_to = params[:return_to]
    enforce_admin
    render :template => '/photo_gallery/galleries/new'
  end

  def create
    @gallery = PhotoGallery::Gallery.new(params[:gallery])
    enforce_admin
    if @gallery.save
      flash[:notice] = "Gallery '#{@gallery.name}' created successfully."
      if params[:return_to].blank?
        redirect_to :action => 'show', :id => @gallery
      else
        redirect_to params[:return_to]
      end
    else
      render :template => '/photo_gallery/galleries/new'
    end
  end

  def destroy
    @gallery = PhotoGallery::Gallery.find_by_id(params[:id])
    enforce_admin
    if @gallery.destroy
      flash[:notice] = "Gallery '#{@gallery.name}' destroyed."
      redirect_to :action => 'index'
    else
      flash[:error] = "Unable to delete '#{@gallery.name}'."
      redirect_to :action => 'show', :id => @gallery
    end
  end

  def sort
    params[:sortable_list].each_with_index do |id, pos|
      PhotoGallery::Gallery.find(id).update_attribute(:position, pos+1)
    end
    render :nothing => true
  end

  private
  def enforce_admin
    unless @admin
      flash[:error] = "You must be an admin to do that."
      redirect_to :action => 'show', :id => @gallery
    end
  end
end
