class PhotoGallery::Admin::PhotosController < PhotoGallery::PhotosController

  before_filter do |controller| 
    controller.instance_eval { @admin = PhotoGallery.admin? }
  end

  def new
    redirect_to :action => 'index' unless @admin
    @photo = PhotoGallery::Photo.new(:gallery_id => params[:gallery_id])
    @return_to = params[:return_to]
    render :template => '/photo_gallery/photos/new'
  end

  def create
    redirect_to :action => 'index' unless @admin
    @photo = PhotoGallery::Photo.new(params[:photo])
    if @photo.save
      flash[:notice] = "Photo uploaded successfully."
      if params[:return_to].blank?
        redirect_to :controller => 'galleries', :action => 'show', :id => @photo.gallery_id
      else
        redirect_to params[:return_to]
      end
    else
      render :template => '/photo_gallery/photos/new'
    end
  end

  def destroy
    redirect_to :action => 'index' unless @admin
    PhotoGallery::Photo.find(params[:id]).destroy
    flash[:notice] = "Photo destroyed successfully."
    redirect_to :action => 'index'
  end
end
