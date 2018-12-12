class UserMailer < ApplicationMailer
  default to: -> { User.where("'admin' = ANY (roles)").pluck(:email) }
  def new_user_email
    @user = params[:user]
    mail(subject: 'New user created!')
  end
end
