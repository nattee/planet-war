class Match < ActiveRecord::Base
  belongs_to :p1_sub, class_name: 'Submission'
  belongs_to :p2_sub, class_name: 'Submission'

  attr_accessible :map, :p1_sub, :p2_sub, :play_at, :score1, :score2
end
