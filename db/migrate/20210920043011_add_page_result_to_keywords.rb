class AddPageResultToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_column :keywords, :page_result, :string
  end
end
