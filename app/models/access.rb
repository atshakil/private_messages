class Access < ApplicationRecord
  belongs_to :user
  belongs_to :message

  enum kind: [:owner, :recipient]
end
