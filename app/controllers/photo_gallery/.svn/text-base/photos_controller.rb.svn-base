class PhotoGallery::PhotosController < ApplicationController
  layout 'photo_gallery'

  def index
    @photos = PhotoGallery::Photo.all
    render :template => '/photo_gallery/photos/index'
  end

  def show
    @photo = Photo.find(params[:id])
    render :template => '/photo_gallery/photos/show'
  end

end
