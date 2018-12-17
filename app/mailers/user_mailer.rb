class UserMailer < ApplicationMailer
  ADMIN_EMAILS = -> { User.where("'admin' = ANY (roles)").pluck(:email) }
  default to: ADMIN_EMAILS
  def new_user_email
    @user = params[:user]
    mail(subject: 'New user created!')
  end

  def user_updated_email
    @user = params[:user]
    @member = Member.find(@user.record_link) if @user.record_link
    to_addr = ADMIN_EMAILS.call << @user.email
    mail(subject: "User Settings for #{@user.display_name} Updated",
         to: to_addr)
  end
end
