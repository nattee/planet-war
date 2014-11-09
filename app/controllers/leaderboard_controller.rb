class LeaderboardController < ApplicationController
  def recent
    @match = Match.where(state: 2).order("ID DESC").limit(50)
  end

  def ranking
  end
end
