module Recurly3
  module Webhook
    class NewUsageNotification < AccountNotification
      # @return [Usage]
      has_one :usage
    end
  end
end
