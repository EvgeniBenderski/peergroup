require 'spec_helper'

describe PagesController do
  before(:each) do
    #
    # Define @base_title here.
    #
    @base_title = "peergroup"
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
  end

  describe "GET 'home'" do

    describe "when not signed in" do
      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end
    end
  end
end
