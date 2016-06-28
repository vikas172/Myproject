class ChatsController < ApplicationController
  before_filter :authenticate_user!

  layout false
#Chat functionality generated
  def create
    if Chat.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Chat.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Chat.create!(conversation_params)
    end

    render json: { conversation_id: @conversation.id }
  end

#chats show view
  def show
    @conversation = Chat.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.chat_messages
    @message = ChatMessage.new
  end


  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
