class PhotoGallery::GalleriesController < ApplicationController
  layout 'photo_gallery'

  def index
    redirect_to :action => 'show', :id => PhotoGallery::Gallery.top
  end

  def show
    @gallery = PhotoGallery::Gallery.find(params[:id])

    @galleries = @gallery.children
    @galleries = @galleries.reject {|gallery| gallery.empty? } unless @admin

    @photos = @gallery.photos
    render :template => '/photo_gallery/galleries/show'
  end
end
