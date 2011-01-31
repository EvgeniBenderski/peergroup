class ChatMessagesController < ApplicationController

  before_filter :authenticate
  before_filter :fetch_group
  before_filter :fetch_chat_room

  def create
    respond_to do |format|
      @chat_message = @chat_room.chat_messages.build(params[:chat_message]) do |chat_message|
        chat_message.user = current_user
      end
      if @chat_message.save
        format.js { head :created }
        format.html { redirect_to group_chat_room_path(@group) }
      else
        format.js { head :bad_request }
        format.html { redirect_to group_chat_room_path(@group) }
      end
    end
  end

  protected

  def fetch_group
    @group = current_user.groups.find(params[:group_id])
  end

  def fetch_chat_room
    @chat_room = @group.chat_rooms.find(params[:chat_room_id])
  end

end
