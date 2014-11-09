class MatchesController < ApplicationController
  def show
    @match = Match.find(params[:id])

    winner = loser = draw = 0
    case @match.winner
    when 0
      draw = 1
    when 1
      winner,loser = [@match.p1_sub.id,@match.p2_sub.id]
    when 2
      loser,winner = [@match.p1_sub.id,@match.p2_sub.id]
    end

    @data =  "game_id=#{params[:id]}\\n"
    @data += "winner=#{winner}\\nloser=#{loser}\\n"
    @data += "map_id=#{@match.map}\\n"
    @data += "map_id=1028\\n"
    @data += "draw=#{draw}\\n"
    @data += "timestamp=#{@match.play_at}\\n"
    @data += "player_one=#{@match.p1_sub.user.login}\\nplayer_two=#{@match.p2_sub.user.login}\\n"
    @data += "worker=141\\n"
    @data += "player_one_id=#{@match.p1_sub.id}\\nplayer_two_id=#{@match.p2_sub.id}\\n"
    @data += "user_one_id=#{@match.p1_sub.user.id}\\nuser_two_id=#{@match.p1_sub.user.id}\\n"
    @data += "playback_string=#{@match.log}"
  end
end
