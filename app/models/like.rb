class Like < ActiveRecord::Base

  # --------------------- Associations --------------------------------
  belongs_to :movie
  belongs_to :user

  # --------------------- Mass Assignment -----------------------------
  attr_accessible :movie_id, :user_id

  # --------------------- Validations --------------------------------
  validates_uniqueness_of :movie_id, scope: :user_id
                   
end
