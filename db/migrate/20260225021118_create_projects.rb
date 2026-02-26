class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :summary
      t.string :status, null: false, default: "planned"

      t.timestamps
    end

    add_index :projects, :status
  end
end
