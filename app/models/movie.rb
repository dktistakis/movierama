# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer
#  likes_count :integer
#  hates_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Movie < ActiveRecord::Base

  # --------------------- Associations --------------------------------
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :hates, dependent: :destroy

  # --------------------- Mass Assignment -----------------------------
  attr_accessible :description, :title, :user_id

  # --------------------- Validations --------------------------------
  validates :title, presence: true,
                    uniqueness: { :case_sensitive => false },
                    length: { maximum: 50}

  validates :description, presence: true,
                          length: { maximum: 300}

  validates :user_id, presence: true

  validate :user_existance

  # ---------------------- Callbacks ----------------------------------


  # -------------- Instance Methods ------------------------------------
  # def own_movie?
  #   self.user == current_user
  # end

  # ----------------- Private Methods ----------------------------------
  private
  
  def user_existance
    unless User.exists?(id: user_id)
      self.errors[:user_id] << 'This user does not exist'
    end
  end
end
