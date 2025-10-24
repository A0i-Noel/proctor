class AddSubmissionToResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :responses, :submission, foreign_key: true, null: true
  end
end
