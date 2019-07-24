class UserMailer < ApplicationMailer
    default from: "samuelmonye00@gmail.com"

  def email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to image worlds')
  end
end
