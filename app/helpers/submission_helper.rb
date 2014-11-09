module SubmissionHelper
  def submission_state_text(st)
    return case 
    when st == -1 then "Cannot be compiled"
    when st ==  0 then "Newly Submitted"
    when st ==  1 then "Compiled"
    when st >=  2 then "Eligible for ranking"
    else "Unknown state!!!"
    end
  end
end
