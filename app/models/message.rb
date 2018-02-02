class Message < ApplicationRecord
  has_many :accesses
  has_many :users, through: :accesses

  scope :received, -> do
      includes(:accesses).where(accesses: {kind: :recipient})# `includes` (optimization only)
  end

  scope :sent, -> do
    includes(:accesses).where(accesses: {kind: :owner})
  end

  def add_recipient *users
    users.each do |user|
      Access.create user: user, message: self, kind: :recipient
    end
  end

  def sender
    accesses.find_by(kind: :owner).user
  end

  def recipients
    users.includes(:accesses).where accesses: {kind: :recipient}
  end
end
