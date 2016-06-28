class Api::V1::ConversationsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

	def chat_user
		if current_user
			if current_user.user_type == "admin"
	        	@users= current_user.team_members.where('member_id IS NOT NULL')
	      	else
		        @users=[]
		        @user = @team_member.user
		        @user_team= @team_member.user.team_members.where("member_id!=?",current_user.id)
		        @users <<  @user
		        if !@user_team.blank?
		          @user_team.each do |team|
		            @users << User.find(team.member_id)
		          end
		        end  
		        @users = @users.flatten
	        end
	        render :status=>200, :json=>@users.as_json
	        #@conversations = Chat.involving(current_user).order("created_at DESC")
		    #render :status=>200, :json=>{:user=>@users.as_json,:conversations=>@conversations.as_json}
		else
			render  :json=>{:status => "Failure Please login" }	
		end		
	end
	def conversation_user
		if current_user
			if Chat.between(params[:conversation_user][:sender_id],params[:conversation_user][:recipient_id]).present?
		      @conversation = Chat.between(params[:conversation_user][:sender_id],params[:conversation_user][:recipient_id]).first
		    else
		      @conversation = Chat.create!(conversation_params)
		    end
		    render json: { conversation_id: @conversation.id }
		else
			render  :json=>{:status => "Failure Please login" }	
		end		
	end

#User click on send then recevier id send 
	def show_message
		@conversation = Chat.find(params[:id])
	    @reciever = interlocutor(@conversation)
	    @messages = @conversation.chat_messages
	    @message = ChatMessage.new
	    render json: {message: @message, reciever: @reciever,messages: @messages}
	end

	def create
	    @conversation = Chat.find(params[:chat_id])
	    @message = @conversation.chat_messages.build(message_params)
	    @message.user_id = current_user.id
	    @message.save!
	    render json: @message
	  end

	private
		def conversation_params
		    params.permit(:sender_id, :recipient_id)
		end
		def current_user
			User.find(params[:user_id]) rescue ""
		end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end

  def message_params
    params.require(:chat_message).permit(:body)
  end
end