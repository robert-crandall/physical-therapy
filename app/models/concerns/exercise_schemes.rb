# app/models/concerns/exercise_schemes.rb
module ExerciseSchemes
  extend ActiveSupport::Concern

  included do
    enum :lift_scheme, {
      thirty_seconds_three_times: 0,
      two_by_fifteen_no_rest: 1
    }
  end

  SCHEMES = {
    thirty_seconds_three_times: {
      sets: 3,
      duration: 30,
      rest: 0
    },
    two_by_fifteen_no_rest: {
      sets: 2,
      reps: 15,
      rest: 0
    },
    three_by_five: {
      sets: 3,
      reps: 5,
      rest: 90
    }
  }.freeze

  def scheme_properties
    SCHEMES[lift_scheme.to_sym] if lift_scheme.present?
  end

  def description
    if duration.present?
      "Hold for #{duration} seconds"
    elsif reps.present?
      "Perform #{reps} reps"
    else
      "Do something"
    end
  end

  def sets
    scheme_properties&.[](:sets)
  end

  def reps
    scheme_properties&.[](:reps)
  end

  def rest_time
    scheme_properties&.[](:rest)
  end

  def duration
    scheme_properties&.[](:duration)
  end

  def sleep_after_exercise_complete
    rest_time.to_i + duration.to_i
  end
end
