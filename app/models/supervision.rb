class Supervision < ActiveRecord::Base

  STEPS = %w{topic topic_vote topic_question finished}

  validates_inclusion_of :state, :in => STEPS

  belongs_to :group
  has_many :topics
  has_many :topic_votes, :through => :topics, :source => :votes
  belongs_to :topic

  scope :unfinished, :conditions => ["state <> ?", "finished"]

  before_validation(:on => :create) { self.state ||= "topic" }

  %w{topics topic_votes}.each do |step|
    define_method(:"all_#{step}?") do
      group.members.all? {|m| !send(step).where(:user_id => m.id).empty? }
    end
  end

  def next_step!
    self.state = STEPS[STEPS.index(state) + 1]
    save!
  end

  def voted_on_topic?(user)
    !topic_votes(true).where(:user_id => user.id).empty?
  end

  def choose_topic
    self.topic = topics.sort {|a,b| a.votes.count <=> b.votes.count}.last
  end
end

