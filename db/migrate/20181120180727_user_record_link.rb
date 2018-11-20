class UserRecordLink < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :record_link, :string, nil: true, default: nil
  end
end
