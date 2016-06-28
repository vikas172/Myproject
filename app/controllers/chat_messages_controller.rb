class ChatMessagesController < ApplicationController
  before_filter :authenticate_user!
  
#Create chat message
  def create
    @conversation = Chat.find(params[:chat_id])
    @message = @conversation.chat_messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:chat_message).permit(:body)
  end
end