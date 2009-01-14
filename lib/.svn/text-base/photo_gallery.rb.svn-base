module PhotoGallery
  CONFIG_FILE = File.join(RAILS_ROOT, 'config', 'photo_gallery.rb')

  # Options...  see config/photo_gallery.rb
  mattr_accessor :admin_check, :image_styles, :image_path, :image_url, :default_image, :title

  def self.init
    load_models
    load_defaults
    load_config(CONFIG_FILE)
    if Gallery.table_exists?
      create_initial_gallery unless Gallery.count > 0
      attach_image_to_model
    else
      RAILS_DEFAULT_LOGGER.error("You must run the PhotoGallery migration to create the appropriate tables before using this plugin") 
    end
  end

  def self.load_config(file)
    if File.exists?(file)
      load file
      RAILS_DEFAULT_LOGGER.info("[PhotoGallery] #{file} loaded.")
    else
      RAILS_DEFAULT_LOGGER.warn("[PhotoGallery] Warning: #{file} does not exist. Plugin defaults will be used.")
    end
  end

  def self.load_defaults
    # The config file (config/photo_gallery.rb) comments on these settings.  It should be kept up to date with whatever is done here.
    self.admin_check = Proc.new { true }

    self.image_styles = {
      :thumb=> "150x150#",
      :large => "1000x1000>"
    }

    self.image_path = ":rails_root/public/photos/:id/:style_:basename.:extension"
    self.image_url = "/photos/:id/:style_:basename.:extension"

    self.default_image = "/images/photo_gallery/empty_gallery.png"
    self.title = "PhotoGallery"
  end

  def self.attach_image_to_model
    Photo.has_attached_file :image,
      :path => image_path,
      :url => image_url,
      :styles => image_styles

    Photo.validates_attachment_presence :image # This must come after .has_attached_file
  end

  def self.create_initial_gallery
    Gallery.create!(:name => "All Galleries")
  end

  def self.admin?
    admin_check.call 
  end
  
  def self.load_models
    Dir[File.join(File.dirname(__FILE__), "..", "app", "models", "photo_gallery", "**", "*.rb")].each do |model|
      require model
    end
  end
end
