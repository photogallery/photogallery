require File.dirname(__FILE__) + '/../../spec_helper'

describe PhotoGallery::Photogenic do
  it "should have a default gallery name" do
    PhotoGallery::Photogenic.const_defined?("DEFAULT_GALLERY_NAME").should == true
  end

  describe "initialization" do
    before :each do
      @top = PhotoGallery::Gallery.new
      @preexisting = PhotoGallery::Gallery.new(:name => "Preexisting")
      @top.children << @preexisting
      PhotoGallery::Gallery.stub!(:top).and_return(@top)
    end

    it "should use an existing gallery if one exists" do
      PhotoGallery::Photogenic.initialize_gallery('Preexisting').should == @preexisting
    end

    it "should create a new gallery if needed" do
      new_gallery = PhotoGallery::Photogenic.initialize_gallery('Something New')
      new_gallery.should be_an_instance_of(PhotoGallery::Gallery)
      new_gallery.should_not == @preexisting
    end
  end

  describe "ClassMethods" do
    it "should be accessible from ActiveRecord::Base" do
      ActiveRecord::Base.should respond_to :acts_as_photogenic
    end

    describe "to associate a photo with a model" do
      before :all do
        class TestPlayer < ActiveRecord::Base
          acts_as_photogenic
        end
      end

      it "should add the association" do
        TestPlayer.instance_methods.should include('photo')

        reflection = TestPlayer.reflect_on_association(:photo)
        reflection.klass.should == PhotoGallery::Photo
      end

      it "should validate the photo" do
        pending
      end

      it "should include any related instance methods" do
        TestPlayer.included_modules.should include(PhotoGallery::Photogenic::InstanceMethods::Photo)
      end
    end

    describe "to associate a collection of photos with a model" do
      before :all do
        class TestGame < ActiveRecord::Base
          attr_accessor :name
          acts_as_photogenic :multiple => true
        end

      end

      it "should add the association" do
        TestGame.instance_methods.should include('gallery')

        reflection = TestGame.reflect_on_association(:gallery)
        reflection.klass.should == PhotoGallery::Gallery
      end

      it "should validate the gallery" do
        pending
      end

      it "should include any related instance methods" do
        TestGame.included_modules.should include(PhotoGallery::Photogenic::InstanceMethods::Gallery)
      end

      it "should cache the containing gallery" do
        base = TestGame.photo_gallery__base_gallery
        base.should be_an_instance_of(PhotoGallery::Gallery)
        base.name.should == "Test Games"
      end

      it "should attach a before_save callback" do
        TestGame.before_save_callback_chain.detect {|callback| callback.method == :photo_gallery__before_save}.should_not be_nil
      end
    end
  end
end

