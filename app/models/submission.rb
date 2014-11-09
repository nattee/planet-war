class Submission < ActiveRecord::Base
  attr_accessible :language, :submitted, :user, :code

  belongs_to :user
  belongs_to :language

  has_many :as_p1, :class_name => "Match", :foreign_key => "p1_sub_id"
  has_many :as_p2, :class_name => "Match", :foreign_key => "p2_sub_id"

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
end
