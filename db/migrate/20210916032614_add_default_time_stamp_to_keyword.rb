class AddDefaultTimeStampToKeyword < ActiveRecord::Migration[6.1]
  def change
    change_column_default :keywords, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :keywords, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
