module Pocus
  # See https://www.icontact.com/developerportal/documentation/client-folders
  class ClientFolder < Resource
    has_many :lists, class: 'List'
    has_many :contacts, class: 'Contact'

    def path
      parent.path+"/c/#{@client_folder_id}"
    end

    def get_lists
      get_multiple('/lists', List)
    end
  end

  class Contact < Resource; end
  class List < Resource; end
end
