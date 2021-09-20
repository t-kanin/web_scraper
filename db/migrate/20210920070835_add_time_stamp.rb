class AddTimeStamp < ActiveRecord::Migration[6.1]
  def change
    change_column_default :search_results, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :search_results, :updated_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :ad_results, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :ad_results, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
