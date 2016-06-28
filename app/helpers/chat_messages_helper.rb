module ChatMessagesHelper
  def self_or_other(message)
    message.user == current_user ? "self" : "other"
  end

  def message_interlocutor(message)
    message.user == message.chat.sender ? message.chat.sender : message.chat.recipient
  end
end
