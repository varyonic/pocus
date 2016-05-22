module Pocus
  # See https://www.icontact.com/developerportal/documentation/client-folders
  class ClientFolder < Resource
    self.path = :c
    self.primary_key = :client_folder_id

    has_many :lists, class: 'List'
    has_many :contacts, class: 'Contact'
    has_many :users, class: 'User'
  end
end
