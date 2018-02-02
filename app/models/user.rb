class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable
  has_many :accesses
  has_many :messages, through: :accesses

  scope :without, ->user {where.not id: user.id}

  def create_message content
    message = Message.create content: content
    Access.create user: self, message: message
  end

  def received_messages
    messages.includes(:accesses).where accesses: {kind: :recipient}
  end
end
