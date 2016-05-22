module Pocus
  # https://www.icontact.com/developerportal/documentation/permissions
  class Permission < Resource
    self.path = :permissions
    self.primary_key = nil
  end
end
