module Pocus
  class Account < Resource
    has_many :clientfolders, path: '/c', class: 'ClientFolder'

    def path
      "/a/#{account_id}"
    end

    def get_clientfolder(client_folder_id)
      get("/c/#{client_folder_id}", ClientFolder)
    end
  end
end
