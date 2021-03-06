require 'spec_helper'

describe RailsApp, "Testing Blameling Integration" do
  context "Controller without Blameling", :type => :controller do
    controller(RailsApp::BlogPostsController) do
      extend(RSpec::Rails::ControllerExampleGroup::BypassRescue)
    end

    before(:each) do
      # Request needs to be setup to avoid path setting error
      @request = ActionController::TestRequest.new
    end

    it "should not set current_user" do
      Thread.new {
        post :create
        # Look in application.rb for the User class and it's id method.
        expect(BlogPost.last.loglings.first.modified_by).to eq(nil)
      }.join
    end
  end

  context "Controller with Blameling", :type => :controller do
    controller(RailsApp::BlamelingController) do
      extend(RSpec::Rails::ControllerExampleGroup::BypassRescue)
    end

    before(:each) do
      # Request needs to be setup to avoid path setting error
      @request = ActionController::TestRequest.new
    end

    it "should set current_user" do
      Thread.new {
        post :create
        # Look in application.rb for the User class and it's id method.
        expect(BlogPost.last.loglings.first.modified_by).to eq(33)
      }.join
    end
  end

  context "Controller with undefined current_user method", :type => :controller do
    controller(RailsApp::NoCurrentUserController) do
      extend(RSpec::Rails::ControllerExampleGroup::BypassRescue)
    end

    before(:each) do
      # Request needs to be setup to avoid path setting error
      @request = ActionController::TestRequest.new
    end

    it "should not set current_user, nor should it error out" do
      Thread.new {
        post :create
        # Look in application.rb for the User class and it's id method.
        expect(BlogPost.last.loglings.first.modified_by).to eq(nil)
      }.join
    end
  end

  context "Controller with a different overridden 'changeling_blame_user' method", :type => :controller do
    controller(RailsApp::CurrentAccountController) do
      extend(RSpec::Rails::ControllerExampleGroup::BypassRescue)
    end

    before(:each) do
      # Request needs to be setup to avoid path setting error
      @request = ActionController::TestRequest.new
    end

    it "should not set current_user if current_user is not defined" do
      Thread.new {
        post :create
        # Look in application.rb for the User class and it's id method.
        expect(BlogPost.last.loglings.first.modified_by).to eq(88)
      }.join
    end
  end
end
