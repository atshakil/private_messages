class Message < ApplicationRecord
  has_many :accesses
  has_many :users, through: :accesses

  scope :received, -> do
      includes(:accesses).where(accesses: {kind: :recipient})# `includes` (optimization only)
  end

  scope :sent, -> do
    includes(:accesses).where(accesses: {kind: :owner})
  end

  def add_recipient user
    Access.create user: user, message: self, kind: :recipient
  end

  def sender
    accesses.find_by(kind: :owner).user
  end
end
