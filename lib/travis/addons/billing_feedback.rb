require 'action_mailer'

module Travis
  module Addons
    module BillingFeedback
      module Mailer
      end

      require 'travis/addons/billing_feedback/task'

      class << self
        def setup
          mailer = ActionMailer::Base
          mailer.delivery_method = :smtp
          mailer.smtp_settings = Travis.config.smtp
          ActionMailer::Base.append_view_path("#{base_dir}/views")
        end

        def base_dir
          File.expand_path('../billing_feedback/mailer', __FILE__)
        end
      end
    end
  end
end
