module Pocus
  # https://www.icontact.com/developerportal/documentation/users
  class User < Resource
    self.path = :users
    self.primary_key = :user_id
  end
end
