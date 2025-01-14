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
        # Week 1
        {
          description: "3x5 linear",
          lifts: [
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 }
          ]
        }
      ]
    },
    five_three_one: {
      weights: true,
      rest: 90,
      sequence: [
        # Week 1
        {
          description: "Week 1: 3x5",
          lifts: [
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 }
          ]
        },
        # Week 2
        {
          description: "Week 2: 3x3",
          lifts: [
            { reps: 3, weight: 1 },
            { reps: 3, weight: 1 },
            { reps: 3, weight: 1 }
          ]
        },
        # Week 3
        {
          description: "Week 3: 3x1",
          lifts: [
            { reps: 5, weight: 1 },
            { reps: 3, weight: 1 },
            { reps: 1, weight: 1 }
          ]
        },
        # Week 4
        {
          description: "Week 4: Deload 3x5",
          lifts: [
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 },
            { reps: 5, weight: 1 }
          ]
        }
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

  def calculated_total
    total = []
    if lift_scheme == "manual"
      (sets || 0).times do |set|
        description = duration.present? ? "Hold for #{duration} seconds" : "Perform #{reps} reps"
        total << { reps: reps, description: description }
      end
    else
      current_sequence[:lifts].each do |lift|
        reps = lift[:reps]
        if lift[:weight].nil?
          description = "Scheme ##{lift_scheme} does not have a weight"
        elsif weight.nil?
          description = "Perform #{reps} reps"
        else
          description = "Perform #{reps} reps at #{calculate_weight(lift[:weight])} lbs"
        end
        total << { reps: reps, description: description }
      end
    end
    total
  end

  def rest_time
    after_lift = rest || scheme&.fetch(:rest, 0)
    during_lift = duration || scheme&.fetch(:duration, 0)
    after_lift.to_i + during_lift.to_i
  end

  ## Rounds calculated weight to the nearest 5 lbs
  def calculate_weight(percentage)
    return nil if weight.nil?

    (weight * percentage / 5).round * 5
  end
end
