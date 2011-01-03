class Vote < ActiveRecord::Base
  include SupervisionRedisPublisher

  belongs_to :user
  belongs_to :statement, :polymorphic => true

  validates_presence_of :user
  validates_presence_of :statement

  attr_accessible

  after_create do |vote|
    case vote.statement
    when Topic
      vote.statement.supervision.post_topic_vote
    when Supervision
      vote.statement.post_vote_for_next_step
    end

    vote.publish_to_redis
  end

  def supervision_id
    case statement
    when Topic
      statement.supervision_id
    when Supervision
      statement_id
    end
  end
  def supervision_publish_attributes
    {:only => [:id, :statement_type, :statement_id, :user_id]}
  end
end

