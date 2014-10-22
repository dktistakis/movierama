class Vote < ActiveRecord::Base

  # --------------------- Associations --------------------------------
  belongs_to :movie
  belongs_to :user

  # --------------------- Mass Assignment -----------------------------
  attr_accessible :movie_id, :user_id, :positive

  # --------------------- Validations --------------------------------
  validates_uniqueness_of :movie_id, scope: :user_id
  validate :self_liking_prevention

  # --------------------- Scopes -------------------------------------
  scope :likes, where(positive: true)
  scope :hates, where(positive: false)

  # --------------------- Callbacks ----------------------------------
  after_save :update_movie_vote_counters
  after_destroy :update_movie_vote_counters

  # --------------------- Private ------------------------------------
  private

  def self_liking_prevention
    if Movie.find(self.movie_id).user == self.user
      self.errors[:user_id] << 'Cannot vote your own movies!'
    end
  end

  def update_movie_vote_counters
    movie.update_attributes(likes_count: movie.votes.likes.count, hates_count: movie.votes.hates.count)
  end

end
