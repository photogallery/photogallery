module PhotoGallery::Photogenic
  DEFAULT_GALLERY_NAME = "Unnamed Gallery"

  def self.included(base)
    base.extend PhotoGallery::Photogenic::ClassMethods
  end

  def self.initialize_gallery(name)
    # Create/find a gallery to hold our photos/galleries
    # In the galleries case, this would yield a gallery named after the model (ie "Games"), and then 
    # each instance of the Game model would have its gallery created under that

    top = PhotoGallery::Gallery.top
    unless gallery = top.children.detect {|g| g.name == name}
      gallery = PhotoGallery::Gallery.create!({:name => name, :parent => top})
    end
    gallery
  end

  module ClassMethods
    def acts_as_photogenic(opts = {})
      opts = {:name => table_name.titleize}.merge opts

      if opts[:multiple] == true
        photogenic_gallery(opts)
      else
        photogenic_photo(opts)
      end
    end

    private
    def photogenic_gallery(opts)
      class_eval do
        belongs_to :gallery, :class_name => "PhotoGallery::Gallery"
        validates_associated :gallery
        include InstanceMethods::Gallery
        alias_method_chain :gallery, :creation
        cattr_accessor :photo_gallery__base_gallery
        before_save :photo_gallery__before_save
      end
      self.photo_gallery__base_gallery = PhotoGallery::Photogenic.initialize_gallery(opts[:name]) unless self.photo_gallery__base_gallery
    end

    def photogenic_photo(opts)
      class_eval do
        belongs_to :photo, :class_name => "PhotoGallery::Photo"
        validates_associated :photo
        cattr_accessor :photo_gallery__gallery
        include InstanceMethods::Photo
      end
      self.photo_gallery__gallery = PhotoGallery::Photogenic.initialize_gallery(opts[:name]) unless self.photo_gallery__gallery
    end
  end

  module InstanceMethods
   module Gallery
      def gallery_with_creation
        # alias_method_chained
        return gallery_without_creation unless gallery_id.nil?

        if self.respond_to?(:name) && !self.name.blank?
          name = self.name 
        else
          name = PhotoGallery::Photogenic::DEFAULT_GALLERY_NAME
        end

        self.gallery = PhotoGallery::Gallery.new(:name => name, :parent => self.class.photo_gallery__base_gallery)
      end

      def photos
        gallery.photos
      end

      def photo_gallery__before_save
        # This method has an important side-effect -- calling #gallery will cause the dynamic creation 
        # of a gallery if one didn't previously exist, so it will be saved alongside the object.  
        # This is important so that we can link to the (empty) gallery without having 
        # to later call my_object.gallery.save
        
        gallery = gallery # cache method return as a local variable
        if gallery.name == PhotoGallery::Photogenic::DEFAULT_GALLERY_NAME || gallery.name != name
          gallery.update_attribute(:name, name)
        end
      end
    end

    module Photo
      def photo_file=(file)
        self.photo = PhotoGallery::Photo.new(:image => file, :gallery => photo_gallery__gallery, :caption => (self.respond_to?(:name) ? name : ""))
      end
    end
  end

end
