class AddIndexNameToTournaments < ActiveRecord::Migration
  def change
    add_index :tournaments, :name, unique: true
  end
end
