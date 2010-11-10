module SupervisionPathsHelper
  def supervision_step_path(supervision)
    supervision.reload
    send("supervision_step_#{supervision.state}_path", supervision)
  end

  def supervision_step_topic_path(supervision)
    if supervision.topics.find_by_author_id(current_user.id)
      topics_path(:supervision_id => supervision.id)
    else
      new_topic_path(:supervision_id => supervision.id)
    end
  end

  def supervision_step_topic_vote_path(supervision)
    topic_votes_path(:supervision_id => supervision.id)
  end
end