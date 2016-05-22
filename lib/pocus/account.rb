module Pocus
  class Account < Resource
    self.path = :a
    self.primary_key = :account_id

    has_many :clientfolders, path: '/c', class: 'ClientFolder'
  end
end
