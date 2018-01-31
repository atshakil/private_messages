class Message < ApplicationRecord
  has_many :accesses
  has_many :users, through: :accesses

  scope :received, ->(from=nil) do
    # sent messages which has user_id(x), pluck id
    if from
      # Message id
      includes(:accesses).where(accesses: {kind: :recipient}, id: )
    else
      includes(:accesses).where(accesses: {kind: :recipient})# `includes` (optimization only)
    end
  end

  scope :sent, ->(to=nil) do
    includes(:accesses).where(accesses: {kind: :owner})
  end

  def add_recipient user
    Access.create user: user, message: self, kind: :recipient
  end

  # def sender
  #   accesses.find_by(kind: :owner).user
  # end
end
