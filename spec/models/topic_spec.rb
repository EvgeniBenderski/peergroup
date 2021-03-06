require 'spec_helper'

describe Topic do
  it "should create a new instance given valid attributes" do
    Factory(:topic)
  end

  describe "user attribute" do
    it "should be required" do
      @topic = Factory.build(:topic, :user => nil)
      @topic.should_not be_valid
      @topic.should have(1).error_on(:user)
    end

    it "should be protected against mass assignment" do
      @user = Factory.build(:user)
      @topic = Factory.build(:topic, :user => @user)
      @another_user = Factory.build(:user)

      @topic.attributes = { :user => @another_user }
      @topic.user.should be == @user
    end
  end

  describe "supervision attribute" do
    it "should be required" do
      # I had to add :user, or factory would fail
      @topic = Factory.build(:topic, :supervision => nil, :user => Factory(:user))
      @topic.should_not be_valid
    end

    it "should be protected agains mass assignment" do
      @supervision = Factory.build(:supervision)
      @topic = Factory.build(:topic, :supervision => @supervision)
      @another_supervision = Factory.build(:supervision)

      @topic.attributes = { :supervision => @another_supervision }
      @topic.supervision.should be == @supervision
    end
  end

  describe "content attribute" do
    it "should not be required" do
      @topic = Factory.build(:topic, :content => nil)
      @topic.should be_valid
    end

    it "should be accessible to mass assignment" do
      @topic = Factory.build(:topic, :content => "simple content")
      @topic.attributes = { :content => "better content" }
      @topic.content.should be == "better content"
    end
  end

  describe "after create" do
    it "should fire #post_topic event on supervision" do
      @supervision = Factory(:supervision)
      @supervision.should_receive(:post_topic)
      @topic = Factory(:topic, :supervision => @supervision)
    end

    it "should publish topic to Redis channel" do
      @topic = Factory.build(:topic)
      @topic.should_receive(:publish_to_redis)
      @topic.save!
    end
  end

  it "should include SupervisionRedisPublisher module" do
    included_modules = Topic.send :included_modules
    included_modules.should include(SupervisionRedisPublisher)
  end

  describe "#supervision_publish_attributed" do
    it "should have only known options" do
      @answer = Topic.new
      @answer.supervision_publish_attributes.should be == {:only => [:id, :content, :user_id]}
    end
  end

end
