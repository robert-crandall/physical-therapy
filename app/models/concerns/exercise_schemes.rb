# app/models/concerns/exercise_schemes.rb
module ExerciseSchemes
  extend ActiveSupport::Concern

  included do
    enum :lift_scheme, {
      thirty_seconds_three_times: 0,
      two_by_fifteen: 1
    }
  end

  SCHEMES = {
    thirty_seconds_three_times: {
      sets: 3,
      duration: 30,
      rest: 30,
      description: "Hold for 30 seconds, repeat 3 times"
    },
    two_by_fifteen: {
      sets: 2,
      reps: 15,
      rest: 60,
      description: "2 sets of 15 reps"
    }
  }.freeze

  def scheme_properties
    SCHEMES[lift_scheme.to_sym] if lift_scheme.present?
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
end
