class AddTitleToSearchResult < ActiveRecord::Migration[6.1]
  def change
    add_column :search_results, :title, :string
  end
end
