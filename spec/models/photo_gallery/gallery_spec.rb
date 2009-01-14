require File.dirname(__FILE__) + '/../../spec_helper'

describe PhotoGallery::Gallery do
  before :all do
    #@gallery = PhotoGallery::Gallery.new(:name => "Gallery")
    @photo1 = PhotoGallery::Photo.new
    @photo2 = PhotoGallery::Photo.new
    @photo3 = PhotoGallery::Photo.new

    PhotoGallery::Photo.stub!(:first).and_return(@photo1)
  end
  
  it "should use a nonstandard table name" do
    PhotoGallery::Gallery.table_name.should == "photo_gallery__galleries"
  end

  it "should have an association to many PhotoGallery::Photos" do
    PhotoGallery::Gallery.reflect_on_association(:photos).macro.should == :has_many
  end

  describe "main photo" do
    before(:all) do
      @gallery_with_photos = PhotoGallery::Gallery.new(:name => "Gallery")
      @gallery_with_photos.photos = [@photo3, @photo2]

      @gallery_without_photos = PhotoGallery::Gallery.new(:name => "Gallery")
    end

    it "should be the first photo in the collection" do
      @gallery_with_photos.main_photo.should == @photo3
    end

    it "should default to nil if the collection is empty" do
      PhotoGallery::Photo.stub!(:first).and_return(@photo1)
      @gallery_without_photos.main_photo.should == nil
    end
  end

  describe "emptiness" do
    before(:all) do
      @empty_gallery = PhotoGallery::Gallery.new

      @gallery_with_photos = PhotoGallery::Gallery.new
      @gallery_with_photos.photos = [@photo3, @photo2]

      @gallery_with_children = PhotoGallery::Gallery.new
      @gallery_with_children.children << @empty_gallery
      @gallery_with_children.children << @gallery_with_photos

      @gallery_with_empty_subgalleries = PhotoGallery::Gallery.new
      @gallery_with_empty_subgalleries.children << @empty_gallery

    end

    describe "based on photos in the collection" do
      it "should be true if there are no photos" do
        @empty_gallery.empty?.should eql true
      end

      it "should be false if there are are photos" do
        @gallery_with_photos.empty?.should eql false
      end
    end

    describe "based on emptiness of subgalleries" do
      it "should be false if there is a non-empty sub-gallery" do
        @gallery_with_children.empty?.should eql false
      end

      it "should be true if there is not a non-empty sub-gallery" do
        @empty_gallery.empty?.should eql true
      end
    end

  end

  describe "validations" do
    it "should require a name" do
      (nameless_gallery = PhotoGallery::Gallery.new).valid?
      nameless_gallery.errors.invalid?(:name)
    end
  end
end

describe PhotoGallery::Gallery, "class methods" do
  before :all do
    @top_gallery = PhotoGallery::Gallery.new(:name => "Top!")
  end

  it "should provide a hierarchical collection of galleries" do
    pending
  end

  it "should keep track of a global top-level gallery" do
    PhotoGallery::Gallery.stub!(:find_by_parent_id).with(nil).and_return(@top_gallery)
    PhotoGallery::Gallery.top.should == @top_gallery
  end
end
