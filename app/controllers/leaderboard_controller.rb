class LeaderboardController < ApplicationController
  def recent
    @match = Match.where(state: 2).order(id: :desc).limit(50)
  end

  def ranking
  end
end
