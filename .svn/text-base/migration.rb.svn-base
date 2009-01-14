class PhotosAndGalleries < ActiveRecord::Migration
  def self.up
    create_table "photo_gallery__galleries", :force => true do |t|
      t.string   "name"
      
      # acts_as_tree
      t.integer  "parent_id", "position"

      t.timestamps
    end

    create_table "photo_gallery__photos", :force => true do |t|
      t.integer  "gallery_id", 'position'
      t.string   "caption", "description"
      t.datetime "date_taken"

      # paperclip
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"

      t.timestamps
    end

  end

  def self.down
    drop_table "photo_gallery__photos"
    drop_table "photo_gallery__galleries"
  end
end
