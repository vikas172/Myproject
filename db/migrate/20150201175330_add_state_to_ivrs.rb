class AddStateToIvrs < ActiveRecord::Migration
  def change
    #pending_activation, active , inactive
    add_column :ivrs, :state, :string
  end
end
