class UserMail < ActionMailer::Base
  default from: "jarode@me.com"
  
  def receive(email)
    page = Page.find_by_address(email.to.first)
    page.email.create(subject: email.subject, body: email.body)
    if email.has_attachments?
      email.attachments.each do |attachment|
        page.attachments.create({file: attachment, description: email.subject})
      end
    end
  end


  def welcome_email(user)
    @user = user
    @url = "#{login_url}"
    mail(to: @user.email, subject: "Bienvenu sur le book de Lety!")
  end
end
