class Match < ActiveRecord::Base
  belongs_to :p1_sub, class_name: 'Submission'
  belongs_to :p2_sub, class_name: 'Submission'
  belongs_to :map

  attr_accessible :map, :p1_sub, :p2_sub, :play_at, :score1, :score2

  #match_type
  CHALLENGE = 0
  COMPULSORY = 1
  QUALIFYING = 2

  def run
    #set up filename
    match_folder = File.join(MATCH_ROOT,self.id.to_s)
    FileUtils.mkdir_p match_folder
    p1_bot = "#{SUBMISSION_ROOT}/#{self.p1_sub.id}"
    p2_bot = "#{SUBMISSION_ROOT}/#{self.p2_sub.id}"
    map_file = WORKSPACE_ROOT+'maps/'+self.map.map_file

    #run the match
    File.open("#{match_folder}/play.py", "w") do |f|
      f.puts "import sys\nimport os"
      f.puts "sys.path.append(os.path.abspath(\"#{File.join(WORKSPACE_ROOT,'backend/')}\"))"
      f.puts "from engine import *"
      f.puts "def main():"
      f.puts "  players = ["
      f.puts "    {\"path\" : \"#{p1_bot}/.\", \"command\" : \"./bot\", \"submission_id\" : #{self.p1_sub_id}},"
      f.puts "    {\"path\" : \"#{p2_bot}/.\", \"command\" : \"./bot\", \"submission_id\" : #{self.p2_sub_id}  }"
      f.puts "  ]"
      f.puts "  print str(play_game(\"#{map_file}\", 1000, #{TURN_LIMIT}, players, True))"
      f.puts "if __name__ == \"__main__\":"
      f.puts "  main()"
    end
    output_file = match_folder + '/output.txt'
    log_file = match_folder + '/log.txt'
    cmd = "python #{match_folder}/play.py"
    puts "Run match #{id}"
    system(cmd,out: log_file, err: "/dev/null")

    #process output
    log_text = File.read(log_file)
    log_text.gsub!(/\'/,'"')
    begin
      result = JSON.parse(log_text)
      self.winner = result["winner"]
      self.log = result["playback"]
      self.play_at = Time.now
      self.state = 2
    rescue
      self.state = -1
    end
    self.save

    puts "  Engine was run successfully"
    puts "  winner is player #{result["winner"]}"

    #handle compulsory match
    if match_type == COMPULSORY then
      if result["winner"] == 1 then
        self.p1_sub.state = Submission::COMPULSORIZED
        self.p1_sub.save
        #gen another compulsory
        self.p1_sub.set_compulsory_match(NAIVE_SUBMISSION_ID,QUALIFYING)
      else
        self.p1_sub.state = Submission::COMPULSORY_FAIL
        self.p1_sub.save
      end
    elsif match_type == QUALIFYING
      if result["winner"] == 1 then
        self.p1_sub.state = Submission::QUALIFIED
        self.p1_sub.save
      else
        self.p1_sub.state = Submission::QUALIFYING_FAIL
        self.p1_sub.save
      end
    end

    puts "Match #{id} is done"
  end

end
