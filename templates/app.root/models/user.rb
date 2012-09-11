class User < ActiveRecord::Base

  attr_accessible :email, :name, :initials, :password, :password_confirmation

  authenticates_with_sorcery!

  validates_length_of       :password, minimum: 3, if: :password
  validates_confirmation_of :password, if: :password

end
