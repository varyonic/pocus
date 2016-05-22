module Pocus
  # https://www.icontact.com/developerportal/documentation/users
  class User < Resource
    self.path = :users
    self.primary_key = :user_id

    has_many :permissions, class: 'Permission'
  end
end
