class UserRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles, :text, array: true, default: []
  end
end
