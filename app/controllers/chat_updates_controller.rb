class ChatUpdatesController < ApplicationController
  include ChatUpdatesInitializer

  before_filter :require_chat_room

  def update
    current_user.seen_on_chat!(@chat_room)
    @chat_update = ChatUpdate.find(params[:id])
    @chat_update.attach_parent!(params[:parent_id]) if params[:parent_id]

    case params[:update_type]
    when "commit"
      @chat_update.commit_message!(params[:chat_update][:message])
      @chat_update = initialized_chat_update
      render :partial => "form", :layout => false
    when "update"
      @chat_update.update_message!(params[:chat_update][:message])
      @chat_updates = @chat_room.chat_updates.newer_than(Time.at(params[:last_update].to_i)).not_new
      render :action => "index"
    else
      raise "Bad update type: #{params[:update_type].inspect}"
    end
  end

  protected

  def require_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

end
