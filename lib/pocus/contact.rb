module Pocus
  # See https://www.icontact.com/developerportal/documentation/contacts
  class Contact < Resource
    self.path = :contacts
    self.primary_key = :contact_id
  end
end
