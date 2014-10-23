class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :likes_count, default: 0
      t.integer :hates_count, default: 0

      t.timestamps
    end
  end
end
