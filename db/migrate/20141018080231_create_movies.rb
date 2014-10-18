class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.integer :likes_count
      t.integer :hates_count

      t.timestamps
    end
  end
end
