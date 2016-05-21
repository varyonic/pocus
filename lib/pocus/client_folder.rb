module Pocus
  # See https://www.icontact.com/developerportal/documentation/client-folders
  class ClientFolder < Resource
    def path
      parent.path+"/c/#{@client_folder_id}"
    end

    def get_lists
      get('/lists', 'lists', List)
    end

    def post_contacts(contacts)
      post_multiple('/contacts', 'contacts', contacts)
    end
  end

  class Contact < Resource; end
  class List < Resource; end
end
