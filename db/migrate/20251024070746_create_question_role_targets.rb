class CreateQuestionRoleTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :question_role_targets do |t|
      t.references :question, null: false, foreign_key: true
      t.references :role,     null: false, foreign_key: true
      t.timestamps
    end
    add_index :question_role_targets, [:question_id, :role_id], unique: true
  end
end