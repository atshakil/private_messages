class Access < ApplicationRecord
  belongs_to :user
  belongs_to :message

  enum kind: [:owner, :recipient]

  # TODO: Enforce DB level uniqueness contraint
  # TODO: Utilize built-in error message scheme, without specifying "message"
  validates :user, uniqueness: {
    scope: :message, message: I18n.t("validation.uniqueness.message_user")
  }

  scope :for_user, ->(user) {where(user: user).pluck :id}
end
