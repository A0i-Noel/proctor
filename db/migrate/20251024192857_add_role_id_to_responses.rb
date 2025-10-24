class AddRoleIdToResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :responses, :role, null: false, foreign_key: true
  end
end
