class Access < ApplicationRecord
  belongs_to :user
  belongs_to :message

  enum kind: [:owner, :recipient]

  scope :for_user, ->(user) {where(user: user).pluck :id}
end
