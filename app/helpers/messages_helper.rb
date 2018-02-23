# TODO: Move methods to decorator
module MessagesHelper
  def recipient_id message
    recipient = message.recipient
    recipient ? recipient.id : 0
  end

  def recipient_name message
    recipient = message.recipient
    recipient.full_name if recipient
  end

  def authorized_edit_message_path message
    link_to("Edit", edit_message_path(@message)) if can? :update, message
  end
end
