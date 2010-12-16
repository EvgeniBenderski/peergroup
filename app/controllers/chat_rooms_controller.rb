class ChatRoomsController < ApplicationController
  before_filter :require_user, :only => [:select_leader, :select_problem_owner]
  before_filter :require_chat_room

  def show
    @chat_users = @chat_room.chat_users.present.by_username
    @chat_update = initialized_chat_update
    current_user.seen_on_chat!(@chat_room)
  end

  def select_leader
    @chat_room.leader = @user
    @chat_room.save!
    render :nothing => true
  end

  def select_problem_owner
    @chat_room.problem_owner = @user
    @chat_room.save!
    render :nothing => true
  end

  protected

  def initialized_chat_update(options = {})
    ChatUpdate.new(options).tap do |chat_update|
      chat_update.user = current_user
      chat_update.chat_room = @chat_room
      chat_update.save!
    end
  end

  def require_user
    @user = User.find(params[:user_id])
  end

  def require_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end
end

