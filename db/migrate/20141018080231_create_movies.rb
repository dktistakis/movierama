class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :likes_count, default: 0
      t.string :hates_count, default: 0

      t.timestamps
    end
  end
end
