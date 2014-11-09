#!/usr/bin/env ruby

#
# ------------------ MAIN FUNCTION --------------------
#
def run_match(match_id)
  match = Match.find_by_id(match_id)
  raise "Cannot find match #{match_id}" unless match
  match.run
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

