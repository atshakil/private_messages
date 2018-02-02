class Message < ApplicationRecord
  has_many :accesses, dependent: :destroy
  has_many :users, through: :accesses

  scope :received, -> do
    includes(:accesses).where(accesses: {kind: :recipient})# `includes` (optimization only)
  end

  scope :sent, -> do
    includes(:accesses).where(accesses: {kind: :owner})
  end

  # TODO: Error message passthrough
  def add_recipient *users
    is_committed = false

    Message.transaction do
      begin
        users.each do |user|
          Access.create!({message: self, kind: :recipient}.merge(
            user.instance_of?(User) ? {user: user} : {user_id: user}
          ))
        end
        is_committed = true
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end

    is_committed
  end

  def commit_with_recipient *users
    is_committed = false

    Message.transaction do
      begin
        self.save!
        users.each do |user|
          Access.create!({message: self, kind: :recipient}.merge(
            user.instance_of?(User) ? {user: user} : {user_id: user}
          ))
        end
        is_committed = true
      rescue ActiveRecord::RecordInvalid => e
        error = e.message.split(":")[-1].strip
          .match(/(?<name>\w*) (?<value>.*)/).named_captures
          .transform_values(&:downcase)
        self.errors.add *error.values

        raise ActiveRecord::Rollback
      end
    end

    is_committed
  end

  def sender
    accesses.find_by(kind: :owner).user
  end

  def recipients
    users.includes(:accesses).where accesses: {kind: :recipient}
  end
end
