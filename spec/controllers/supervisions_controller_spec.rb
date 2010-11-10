require 'spec_helper'

describe SupervisionsController do
  before do
    @group = Factory(:group)
    @founder = @group.founder
  end

  def mock_current_supervision_with(supervision)
    Group.should_receive(:find).with(@group.id).and_return(@group)
    @group.should_receive(:current_supervision).and_return(supervision)
  end

  describe "new" do
    context "when current supervision already exists" do
      before { mock_current_supervision_with(@supervision = @group.supervisions.create!) }

      it "should redirect to show current supervision" do
        get :new, :group_id => @group.id
        response.should redirect_to(supervision_path(@supervision))
      end
    end

    context "when no current supervision" do
      before { mock_current_supervision_with(nil) }

      it "should display new supervision question" do
        get :new, :group_id => @group.id
        response.should render_template("new")
      end
    end
  end

  describe "create" do

    context "when supervision already exists" do
      before do
        mock_current_supervision_with(@supervision = @group.supervisions.create!)
        post :create, :group_id => @group.id
      end

      specify { response.should redirect_to(supervision_path(@supervision)) }
      specify { @group.supervisions.count.should == 1 }
    end

    context "when no current supervision" do
      before do
        mock_current_supervision_with(nil)
        post :create, :group_id => @group.id
        @current_supervision = @group.supervisions.first
      end

      specify { @current_supervision.should_not be_nil }
      specify { response.should redirect_to(supervision_path(@current_supervision)) }
    end
  end

  describe "show" do
    context "when in choose topic state" do
      before do
        @supervision = @group.supervisions.create!(:state => "topic")
        get :show, :id => @supervision.id
      end

      specify { response.should redirect_to(new_topic_path(:supervision_id => @supervision.id)) }
    end
  end
end
