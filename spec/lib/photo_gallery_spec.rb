require File.dirname(__FILE__) + '/../spec_helper'

describe PhotoGallery do
  it "should know how to initialize the library" do
    PhotoGallery::Gallery.stub!(:count).and_return(0)
    PhotoGallery.should_receive(:load_models)
    PhotoGallery.should_receive(:load_defaults)
    PhotoGallery.should_receive(:load_config)
    PhotoGallery.should_receive(:create_initial_gallery)
    PhotoGallery.should_receive(:attach_image_to_model)
    PhotoGallery.init
  end

  describe "loading a config file" do
    before :all do
      @filename = "config/photo_gallery.rb"
    end

    it "should fail gracefully if the file is absent" do
      File.stub!(:exists?).with(@filename).and_return(false)
      lambda { PhotoGallery.load_config(@filename) }.should_not raise_error
    end

    it "should load the file if it exists" do
      # See below for tests related to contents of the config file and defaults
      File.stub!(:exists?).with(@filename).and_return(true)
      PhotoGallery.should_receive(:load).with(@filename)
      PhotoGallery.load_config(@filename)
    end
  end

  describe "associating an image with a model" do
    it "should set correct paperclip properties" do
      PhotoGallery::Photo.should_receive(:has_attached_file).with(:image, {:path => PhotoGallery.image_path, :url => PhotoGallery.image_url, :styles => PhotoGallery.image_styles})
      PhotoGallery.attach_image_to_model
    end
  end

  it "should know how to create the top-level gallery" do
    PhotoGallery::Gallery.should_receive(:create!).with(:name => "All Galleries")
    PhotoGallery.create_initial_gallery
  end

  it "should provide an accessor for admin_check" do
    PhotoGallery.admin_check = Proc.new { "checking admin" }
    PhotoGallery.admin?.should == "checking admin"
  end

  it "should load the required models from the plugin dir" do
    lambda { PhotoGallery.load_models }.should_not raise_error
    PhotoGallery.const_defined?('Photo').should == true
    PhotoGallery.const_defined?('Gallery').should == true
  end
end

describe PhotoGallery, "config options" do
  it "should allow user to specify how admin-mode is determined" do
    PhotoGallery.should respond_to :admin_check=
  end

  it "should allow user to specify the sizes of photos that are kept/created" do
    PhotoGallery.should respond_to :image_styles=
  end

  it "should allow user to specify where images are saved on the system" do
    PhotoGallery.should respond_to :image_path=
    PhotoGallery.should respond_to :image_url=
  end

  describe "defaults" do
    before :all do
      PhotoGallery.load_defaults
    end

    after :all do
      PhotoGallery.load_config(PhotoGallery::CONFIG_FILE)
    end

    it "should include admin_check" do
      PhotoGallery.admin_check.call(nil).should == true
    end

    it "should include image size preferences" do
      PhotoGallery.image_styles.keys.should include :thumb, :large
    end

    it "should include a location for image image storage" do
      PhotoGallery.image_path.should be_an_instance_of(String)
      PhotoGallery.image_url.should be_an_instance_of(String)
    end

    it "should have an appropriate relationship for the image storage locations" do
      (PhotoGallery.image_path =~ /#{PhotoGallery.image_url}$/).should_not be_nil
    end
  end
end
