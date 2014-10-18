class Movie < ActiveRecord::Base
  attr_accessible :description, :hates_count, :likes_count, :title, :user_id
end
