class AddTargetRoleIdsToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :target_role_ids, :string, array: true, default: [], null: false
    add_index :questions, :target_role_ids, using: :gin
  end
end