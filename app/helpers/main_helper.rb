module MainHelper
  def match_text(match) 
    case match.state
    when -1
      return "server error"
    when 0
      return "Scheduled"
    when 1
      return "In progress"
    when 2
      return "Completed " + link_to("(view)", match_path(match))
    end
  end
end
