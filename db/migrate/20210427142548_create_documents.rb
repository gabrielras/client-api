class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents, id: :uuid do |t|
      t.string :path, null: false
      t.string :content_base64, null: false
      t.date :deadline_at, null: false
      t.boolean :auto_close, default: true, null: false
      t.boolean :sequence_enabled, default: false, null: false
      t.integer :remind_interval, default: 3, null: false
      t.string :state

      t.timestamps
    end
  end
end
