class Task < ActiveRecord::Base
  attr_accessible :finished_at, :state, :type
end
