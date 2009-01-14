require 'action_controller/dispatcher'

require File.join(File.dirname(__FILE__), "lib", "photo_gallery") # Absolute path required since we name our config file after the module
require File.join(File.dirname(__FILE__), "..", "..", "..", "app", "controllers", "application")

controller_path = File.join(directory, 'app', 'controllers')

# Not sure which of these are actually needed...
$LOAD_PATH << controller_path
ActiveSupport::Dependencies.load_paths << controller_path
config.controller_paths << controller_path

view_path = File.join(directory, 'app', 'views')
ActionController::Base.append_view_path view_path

ActiveRecord::Base.send(:include, PhotoGallery::Photogenic)
ApplicationController.send(:helper, PhotoGallery::ViewHelper)

ActionController::Dispatcher.to_prepare(:plainly_stated__photo_gallery) do
  PhotoGallery.init
end
