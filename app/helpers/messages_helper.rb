# TODO: Move methods to decorator
module MessagesHelper
  def recipient_id message
    recipients = message.recipients
    recipients.empty? ? 0 : recipients.last.id
  end
end
