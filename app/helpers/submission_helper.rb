module SubmissionHelper
  def submission_state_text(st)
    return case 
    when st == -3 then "lost to naive bot"
    when st == -2 then "lost to compulsory bot"
    when st == -1 then "Cannot be compiled"
    when st ==  0 then "Newly Submitted"
    when st ==  1 then "Compiled"
    when st ==  2 then "Pass Compulsory Round"
    when st >=  3 then "Qualified for Ranking"
    else "Unknown state!!!"
    end
  end
end
