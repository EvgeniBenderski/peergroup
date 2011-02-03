$:.unshift File.join(File.dirname(__FILE__), "..")
require "spec_helper"

describe SolutionsController do
  before do
    @group = Factory(:group)
    @user = @group.founder
    test_sign_in(@user)

    @supervision = Factory(:supervision, :group => @group, :state => "providing_solutions")
  end

  describe "#show with partial=1 param" do
    before do
      @solution = Factory(:solution, :supervision => @supervision)
      get :show,
        :supervision_id => @supervision.id,
        :id => @solution.id,
        :partial => 1
    end

    specify { response.should be_success }
    specify { response.should render_template("solution") }
    specify { response.should_not render_template("show") }
  end

  describe "#create" do
    describe "with valida data" do
      before do
        post :create,
          :supervision_id => @supervision.id,
          :solution => { :content => "Solution content" }
      end

      specify { response.should redirect_to(supervision_path(@supervision)) }
      specify { flash[:notice].should be_present }
    end

    describe "with invalid data" do
      before do
        post :create,
          :supervision_id => @supervision.id,
          :solution => {}
      end

      specify { response.should redirect_to(supervision_path(@supervision)) }
      specify { flash[:alert].should be_present }
    end
  end

  describe "#create.json" do
    describe "with valida data" do
      before do
        post :create,
          :format => :json,
          :supervision_id => @supervision.id,
          :solution => { :content => "Solution content" }
      end

      specify { response.should be_success }
      specify do
        json = JSON.restore(response.body)
        json["flash"].should be_present
        json["flash"]["notice"].should be_present
      end
    end

    describe "with invalid data" do
      before do
        post :create,
          :format => :json,
          :supervision_id => @supervision.id,
          :solution => {}
      end

      specify { response.should_not be_success }
      specify do
        json = JSON.restore(response.body)
        json["flash"].should be_present
        json["flash"]["alert"].should be_present
      end
    end
  end

  describe "#update" do
    describe "with valida data" do
      before do
        @solution = Factory(:solution, :supervision => @supervision)
        put :update,
          :supervision_id => @supervision.id,
          :id => @solution.id,
          :solution => { :ratign => "3" }
      end

      specify { response.should redirect_to(supervision_path(@supervision)) }
      specify { flash[:notice].should be_present }
    end

    describe "with invalid data" do
      before do
        @solution = Factory(:solution, :supervision => @supervision)
        put :update,
          :supervision_id => @supervision.id,
          :id => @solution.id,
          :solution => { :rating => "none" }
      end

      specify { response.should redirect_to(supervision_path(@supervision)) }
      specify { flash[:alert].should be_present }
    end
  end

  describe "#update.json" do
    describe "with valida data" do
      before do
        @solution = Factory(:solution, :supervision => @supervision)
        put :update,
          :format => :json,
          :supervision_id => @supervision.id,
          :id => @solution.id,
          :solution => { :rating => "3" }
      end

      specify { response.should be_success }
      specify do
        json = JSON.restore(response.body)
        json["flash"].should be_present
        json["flash"]["notice"].should be_present
      end
    end

    describe "with invalid data" do
      before do
        @solution = Factory(:solution, :supervision => @supervision)
        post :create,
          :format => :json,
          :supervision_id => @supervision.id,
          :id => @solution.id,
          :solution => { :rating => "none" }
      end

      specify { response.should_not be_success }
      specify do
        json = JSON.restore(response.body)
        json["flash"].should be_present
        json["flash"]["alert"].should be_present
      end
    end

  end
end