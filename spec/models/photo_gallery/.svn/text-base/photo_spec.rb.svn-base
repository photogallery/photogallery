require File.dirname(__FILE__) + '/../../spec_helper'

describe PhotoGallery::Photo do
  it "should use a nonstandard table name" do
    PhotoGallery::Photo.table_name.should == "photo_gallery__photos"
  end

  it "should have an association to a PhotoGallery::Gallery" do
    PhotoGallery::Photo.reflect_on_association(:gallery).should_not eql nil 
  end
end
