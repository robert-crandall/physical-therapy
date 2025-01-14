# app/models/concerns/exercise_schemes.rb
module ExerciseSchemes
  extend ActiveSupport::Concern

  included do
    enum :lift_scheme, {
      manual: 0,
      three_by_five_linear: 1,
      five_three_one: 2
    }
  end

  SCHEMES = {
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
    return nil if manual?

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

  def calculated_total
    total = []
    if lift_scheme == "manual"
      calculated_sets.times do |set|
        total << { reps: calculated_reps }
      end
    else
      total << { reps: calculated_reps }
    end
    total
  end

  def calculated_sets
    sets || current_sequence&.[](:sets) || 0
  end

  def calculated_reps
    reps || current_sequence&.[](:reps) || 0
  end

  def calculated_rest_time
    rest || current_sequence&.[](:rest) || 0
  end

  def calculated_duration
    duration || current_sequence&.[](:duration) || 0
  end

  def sleep_after_exercise_complete
    calculated_rest_time.to_i + calculated_duration.to_i
  end
end
