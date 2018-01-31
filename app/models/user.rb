class User < ApplicationRecord
  has_many :accesses
  has_many :messages, through: :accesses


end
