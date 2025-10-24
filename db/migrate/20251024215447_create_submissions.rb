class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.jsonb :metadata

      t.timestamps
    end
  end
end
