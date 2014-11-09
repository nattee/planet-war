#!/usr/bin/env ruby

#
# ------------------ MAIN FUNCTION --------------------
#
def run_match(match_id)
  match = Match.find_by_id(match_id)
  raise "Cannot find match #{match_id}" unless match

  #set up filename
  match_folder = File.join(MATCH_ROOT,match_id.to_s)
  FileUtils.mkdir_p match_folder
  p1_bot = "#{SUBMISSION_ROOT}/#{match.p1_sub.id}"
  p2_bot = "#{SUBMISSION_ROOT}/#{match.p2_sub.id}"
  map_file = WORKSPACE_ROOT+'maps/'+match.map

  #run the match
  File.open("#{match_folder}/play.py", "w") do |f|
    f.puts "import sys\nimport os"
    f.puts "sys.path.append(os.path.abspath(\"#{File.join(WORKSPACE_ROOT,'backend/')}\"))"
    f.puts "from engine import *"
    f.puts "def main():"
    f.puts "  players = ["
    f.puts "    {\"path\" : \"#{p1_bot}/.\", \"command\" : \"./bot\"},"
    f.puts "    {\"path\" : \"#{p2_bot}/.\", \"command\" : \"./bot\"}"
    f.puts "  ]"
    f.puts "  print str(play_game(\"#{map_file}\", 1000, #{TURN_LIMIT}, players, True))"
    f.puts "if __name__ == \"__main__\":"
    f.puts "  main()"
  end
  output_file = match_folder + '/output.txt'
  log_file = match_folder + '/log.txt'
  cmd = "python #{match_folder}/play.py"
  system(cmd,out: log_file, err: "/dev/null")

  #process output
  log_text = File.read(log_file)
  log_text.gsub!(/\'/,'"')
  result = JSON.parse(log_text)
  match.winner = result["winner"]
  match.log = result["playback"]
  match.play_at = Time.now
  match.state = 2
  match.save

  puts "Match #{match_id} was run successfully"
  puts "  winner is player #{result["winner"]}"
end

#
# ------ SCRIPT HANDLER ---------------
#
if __FILE__ == $0 then
  require File.join(File.dirname(__FILE__),'../config/environment')
  #require File.join(File.dirname(__FILE__),'../config/initializers/planet_war_config.rb')
  puts "Rails environment loaded"


  #process option and display usage
  if ARGV.length == 0 then
    puts "Usage: run_match [match_id]"
    exit
  end

  begin
    run_match(ARGV[0])
  rescue Exception => e
    $stderr.puts e.backtrace

    abort(e.message)
  end
end

