class PhotoGallery::Photo < ActiveRecord::Base
  set_table_name 'photo_gallery__photos'
  
  belongs_to :gallery, :class_name => "PhotoGallery::Gallery"

end
