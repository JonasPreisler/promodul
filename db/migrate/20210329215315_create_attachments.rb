class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :attached_on, polymorphic: true, index: true
      t.string     :file,   limit: 50
      t.uuid       :uuid,                       null: false
      t.datetime   :exp_date
      t.boolean    :is_active, null: false,  default: true
    end
  end
end
