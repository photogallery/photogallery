module PhotoGallery
  #
  # The following options can be specified to configure the PhotoGallery plugin.
  # The commented-out examples show the default behavior.
  # 
  # NOTE: Changing values here will not affect images that have already been uploaded.
  #

  ### Define the logic used to tell if a user is allowed to act as an admin
  # self.admin_check = Proc.new { true }

  ### Choose the images that will be created.  The plugin uses :thumb and :large by default
  # self.image_styles = {
  #       :thumb=> "150x150#",
  #       :large => "1000x1000>"
  #     }

  ### Chose where uploaded images will be stored.  These two must match, as shown.
  # self.image_path = ":rails_root/public/photos/:id/:style_:basename.:extension" # (this is where the file will be saved on your system"
  # self.image_url = "/photos/:id/:style_:basename.:extension" # (this is the url to the file)
  
  ### The image used for empty galleries (only shows up for admins...  non-admins don't see empty galleries)
  # self.default_image = "/images/photo_gallery/empty_gallery.png"
  
  ### The HTML <title> for your gallery
  # self.title = "PhotoGallery"
end
