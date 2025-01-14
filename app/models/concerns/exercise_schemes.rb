# app/models/concerns/exercise_schemes.rb
module ExerciseSchemes
  extend ActiveSupport::Concern

  included do
    enum :lift_scheme, {
      thirty_seconds_three_times: 0,
      two_by_fifteen_no_rest: 1,
      three_by_five_linear: 2,
      five_three_one: 3
    }
  end

  SCHEMES = {
    thirty_seconds_three_times: {
      rest: 0,
      weights: false,
      sequence: [
        { sets: 3, duration: 30 }
      ]
    },
    two_by_fifteen_no_rest: {
      rest: 0,
      weights: false,
      sequence: [
        { sets: 2, reps: 15 }
      ]
    },
    three_by_five_linear: {
      rest: 90,
      weights: true,
      sequence: [
        { sets: 3, reps: 5, increment_weight: true }
      ]
    },
    five_three_one: {
      weights: true,
      rest: 90,
      sequence: [
        { sets: 3, reps: 5, description: "Week 1: 3x5", increment_weight: true },
        { sets: 3, reps: 3, description: "Week 2: 3x3" },
        { sets: 3, reps: 1, description: "Week 3: 3x1" },
        { sets: 3, reps: 5, description: "Week 4: Deload 3x5" }
      ]
    }
  }.freeze

  def scheme
    return nil unless lift_scheme.present?

    @scheme ||= SCHEMES[lift_scheme.to_sym]
  end

  def current_sequence
    return nil unless lift_scheme.present?

    @current_sequence ||= begin
      scheme = SCHEMES[lift_scheme.to_sym]
      current_sequence = exercise_histories.last&.sequence_position || 0
      scheme[:sequence][current_sequence % scheme[:sequence].length]
    end
  end

  def current_sequence_description
    return nil unless current_sequence
    current_sequence[:description]
  end

  def description
    if duration.present?
      "Hold for #{duration} seconds"
    elsif reps.present?
      if weights.present? && weights
        "Perform #{reps} reps at #{self.weight} lbs"
      else
        "Perform #{reps} reps"
      end
    else
      "Do something"
    end
  end

  def weights
    scheme&.[](:weights)
  end

  def sets
    current_sequence&.[](:sets)
  end

  def reps
    current_sequence&.[](:reps)
  end

  def rest_time
    current_sequence&.[](:rest)
  end

  def duration
    current_sequence&.[](:duration)
  end

  def sleep_after_exercise_complete
    rest_time.to_i + duration.to_i
  end
end
