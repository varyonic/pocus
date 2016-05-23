module Pocus
  class Subscription < Resource
    self.path = :subscriptions
    self.primary_key = :subscription_id
  end
end
