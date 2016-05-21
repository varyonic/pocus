module Pocus
  class Account < Resource
    attr_accessor :session

    def path
      "/a/#{account_id}"
    end

    def get_clientfolder(client_folder_id)
      get("/c/#{client_folder_id}", 'clientfolder', ClientFolder)
    end

    def get_clientfolders(filters = {})
      logger.info("get_clientfolders(#{filters.inspect})")
      get('/c', 'clientfolders', ClientFolder, filters)
    end
  end
end
