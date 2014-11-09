module MainHelper
  def match_text(match) 
    case match.state
    when 0
      return "scheduled"
    when 1
      return "in progress"
    when 2
      return link_to("(view)", match_path(match))
    end
  end
end
