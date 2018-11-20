class AdditionalUserInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :display_name, :string
    add_column :users, :job_title, :string
  end
end
