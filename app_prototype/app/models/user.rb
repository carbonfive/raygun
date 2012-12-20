class User < ActiveRecord::Base

  attr_accessible :name, :email, :password, :password_confirmation

  authenticates_with_sorcery!

  validates :email,
            presence: true,
            email: true

  validates :password,
            presence: true,
            length: { minimum: 6 },
            if: :password

end
