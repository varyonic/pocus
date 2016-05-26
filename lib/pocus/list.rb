module Pocus
  # See https://www.icontact.com/developerportal/documentation/lists
  class List < Resource
    self.path = :lists
    self.primary_key = :list_id
  end
end
