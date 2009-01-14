class PhotoGallery::Gallery < ActiveRecord::Base
  set_table_name 'photo_gallery__galleries'
  
  has_many :photos, :class_name => "PhotoGallery::Photo"

  acts_as_tree :order => "position"
  validates_presence_of "name"

  def self.top
    find_by_parent_id(nil)
  end

  def self.collection_for_select(current = nil, collection = [], depth = 0)
    # Recursive method to generate a nice dropdown showing all graphs hierarchically
    
    current = top unless current
    if depth == 0
      depth_indicator = ""
    else
      depth_indicator = "-" * (depth - 1) + "> "
    end
    collection << [depth_indicator + current.name, current.id]

    current.children.each {|child| collection_for_select(child, collection, depth + 1) }

    collection
  end

  def main_photo
    if photos.empty?
      gallery_with_photo = children.detect {|g| g.main_photo }
      gallery_with_photo.nil? ? nil : gallery_with_photo.main_photo
    else
      photos[0]
    end
  end

  def thumb
  end

  def empty?
    if photos.empty? && children.reject {|gallery| gallery.empty?}.empty?
      true
    else
      false
    end
  end
end
