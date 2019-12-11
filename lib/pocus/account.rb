module Pocus
  class Account < Resource
    self.path = :a
    self.primary_key = :account_id

    attr_accessor :session
    has_many :clientfolders, path: '/c', class: 'ClientFolder'
    has_many :users, class: 'User'
  end
end
