class UsersController < ApplicationController
  before_action :authorize_admin

  def index
    @users = User.order(:display_name)
    @members = Member.all(sort: {'Pseudonym' => 'asc'})
  end

  def bulk_update
    changes = []
    user_params = params.permit(users: {}).to_h.fetch(:users)
    user_params.each do |user_id, fields|
      fields[:roles].reject! { |v| v.nil? || v.empty? }
      fields.reject! { |_k, v| v.nil? || v.empty? }
      u = User.find(user_id)
      u.attributes = fields
      if u.changed?
        changes << "User `#{u.display_name}` updated!"
        u.save
        UserMailer.with(user: u).user_updated_email.deliver_later
      end
    end
    if changes.length > 0
      flash[:sucess] = changes
    else
      flash[:info] = "No changes detected."
    end
    redirect_to action: 'index' 
  end
end
