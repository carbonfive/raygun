class UserSession
  include ActiveAttr::BasicModel
  include ActiveAttr::MassAssignment

  attr_accessor :email, :password, :remember_me
end
