module Pocus
  # See https://www.icontact.com/developerportal/documentation/custom-fields
  class CustomField < Resource
    self.path = :customfields
    self.primary_key = :custom_field_id
  end
end
