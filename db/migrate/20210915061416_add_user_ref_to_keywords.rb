class AddUserRefToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_reference :keywords, :user, null: false, foreign_key: true
  end
end
