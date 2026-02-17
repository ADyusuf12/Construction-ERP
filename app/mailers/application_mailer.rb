class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@earmark-systems.test"
  layout "mailer"
end
