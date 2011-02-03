class TopicVotesController < ApplicationController
  self.responder = SupervisionPartResponder

  before_filter :authenticate
  before_filter :require_parent_supervision
  before_filter :fetch_topic
  require_supervision_step :voting_on_topics

  respond_to :html, :json

  def create
    @vote = @topic.votes.build do |vote|
      vote.user = current_user
    end
    @vote.save
    respond_with(@vote, :location => supervision_topics_path(@supervision))
  end

  protected

  def fetch_topic
    @topic = @supervision.topics.find(params[:topic_id])
  end
end

