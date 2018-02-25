class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable
  has_many :accesses
  has_many :messages, through: :accesses

  validates :first_name, :last_name, presence: true, length: {minimum: 2}

  scope :without, ->user {where.not id: user.id}

  def create_message content
    message = Message.create content: content
    Access.create user: self, message: message
  end

  def sent_messages
    messages.includes(:accesses).where accesses: {kind: :owner}
  end

  def received_messages
    messages.includes(:accesses).where accesses: {kind: :recipient}
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
