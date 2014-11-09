class Submission < ActiveRecord::Base
  attr_accessible :language, :submitted, :user, :code

  belongs_to :user
  belongs_to :language

  has_many :as_p1, :class_name => "Match", :foreign_key => "p1_sub_id"
  has_many :as_p2, :class_name => "Match", :foreign_key => "p2_sub_id"

  #state
  QUALIFYING_FAIL = -3
  COMPULSORY_FAIL = -2
  COMPILED_FAIL = -1
  NEWLY_SUBMIT = 0
  COMPILED = 1
  COMPULSORIZED = 2
  QUALIFIED = 3



  def do_compile
    #prepare folder
    folder = SUBMISSION_ROOT+"/#{self.id}/"
    FileUtils.remove_dir(folder) if File.exist?(folder)
    FileUtils.mkdir_p(folder)

    #save source file
    source_name = folder + self.filename
    File.open(source_name,'w') { |f| f.write(self.code) }

    #compile
    compiler_message = folder + "compiler_message"
    bot_name = folder + "bot"
    case self.language.name
    when "cpp"
      cmd = "g++ -o #{bot_name} #{source_name} #{WORKSPACE_ROOT}/lib/cpp/PlanetWars.cc -I#{WORKSPACE_ROOT}/lib/cpp"
      puts "cmd = #{cmd}"
      system(cmd,err: compiler_message)
      self.compiler_message = File.read(compiler_message)
      unless File.exists?(bot_name) then
        self.state = -1
        self.save
        raise "Compilation error"
      end
    when "java"

    end

    #save state
    self.state = 1
    self.save
  end

  def process_new_submission
    do_compile
    if state == 1 then
      set_compulsory_match(NOOP_SUBMISSION_ID,Match::COMPULSORY)
    end
  end

  def set_compulsory_match(compulsory_id,match_type)
    m = Match.where(p1_sub_id: self.id, p2_sub_id: compulsory_id)

    if (m.size > 0) then
      t = Task.where(match_id: m[0].id)
      t.each {|x| x.destroy}
      m.each {|x| x.destroy}
    end

    m = Match.new
    m.p1_sub = self
    m.p2_sub_id = compulsory_id
    m.match_type = match_type
    m.map = Map.get_random
    m.save

    t = Task.new
    t.priority = 1
    t.match_id = m.id
    t.save
  end
end
