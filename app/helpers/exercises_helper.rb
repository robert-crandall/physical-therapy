module ExercisesHelper
  def plate_color_class(weight)
    case weight
    when 45 then "text-primary"  # blue
    when 35 then "text-warning"  # yellow
    when 25 then "text-success"  # green
    when 10 then "text-danger"   # red
    when 5  then "text-info"     # light blue
    else "text-secondary"        # grey
    end
  end
end
