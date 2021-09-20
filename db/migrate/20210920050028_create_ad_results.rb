class CreateAdResults < ActiveRecord::Migration[6.1]
  def change
    create_table :ad_results do |t|
      t.string :title
      t.string :url
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
