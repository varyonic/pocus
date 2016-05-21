module Pocus
  class Account < Resource
    has_many :clientfolders, path: '/c', class: 'ClientFolder'

    def path
      "/a/#{account_id}"
    end
  end
end
