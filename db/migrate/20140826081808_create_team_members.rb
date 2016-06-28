class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :member_id
      t.integer :user_id
      t.boolean :active, default: true
      t.boolean :login_access, default: true

      t.timestamps
    end
  end
end
