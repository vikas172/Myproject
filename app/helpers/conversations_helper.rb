module ConversationsHelper

	def get_conversation_body(sent)
		message=Mailboxer::Message.find_by_conversation_id(sent.id) rescue ""
		message_sender=Mailboxer::Notification.where(:sender_id=>current_user.id).collect(&:id) rescue ""
		receiver_name=Mailboxer::Receipt.where(:notification_id=>message_sender , :mailbox_type=>"inbox") rescue ""
		return message.body
	end

	def get_receiver_name(sent)
	
		message=Mailboxer::Message.find_by_conversation_id(sent.id) rescue ""
		message_sender=Mailboxer::Notification.find(message.id) rescue ""
		# receiver_name=Mailboxer::Receipt.where(:notification_id=>message_sender , :mailbox_type=>"inbox")
		receiver_name=Mailboxer::Receipt.find_by_notification_id(message_sender.id) rescue ""
		user_receive=User.find(receiver_name.receiver_id).email rescue ""
		return user_receive
	end

	def get_sender_inbox(message)
		# message1=Mailboxer::Message.find_by_conversation_id(message.id) rescue ""
		message_sender=Mailboxer::Notification.where("conversation_id =? and sender_id!=?",message.id,current_user.id)
	  user_receive = User.find(message_sender.first.sender_id).email rescue ""
	  return user_receive
	end

	def get_sender_notify(notify)
		if !notify.blank?
			message=Mailboxer::Message.find_by_conversation_id(notify.id)
			user=User.find(message.sender_id) rescue ""
			if !user.blank?
				return user.full_name
      else
      	return ""
      end		 
		end
	end

	def get_display_notify_new(message)
		user=User.find(message.sender_id) rescue ""
		if !user.blank?
			return user.full_name
  		else
  			return ""
  		end		 
	end


	def get_job_notify_new(job)
		if !job.blank?
			job = job.crew
			user= User.find(job) rescue ""
			if !user.blank?
				return user.first.full_name
      else
      	return ""
      end	
		end
	end

	def get_job_notify(job)
		if !job.blank?
			user_name =  job.crew
			user= User.find(user_name) rescue ""
			if !user.blank?
				return user.full_name
      else
      	return ""
      end	
		end
	end

end
