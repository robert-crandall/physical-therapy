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

  BAR_WEIGHT = 45
  WEIGHT_PLATES = [ 45, 25, 10, 5, 2.5 ].freeze

  SCHEMES = {
    three_by_five_linear: {
      rest: 90,
      weights: true,
      sequence: [
        # Week 1
        {
          description: "3x5 linear",
          lifts: [
            { reps: 5, percentage: 0.85 },
            { reps: 5, percentage: 0.85 },
            { reps: 5, percentage: 0.85 }
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
            { reps: 5, percentage: 0.65 },
            { reps: 5, percentage: 0.75 },
            { reps: 5, percentage: 0.85 }
          ]
        },
        # Week 2
        {
          description: "Week 2: 3x3",
          lifts: [
            { reps: 3, percentage: 0.70 },
            { reps: 3, percentage: 0.80 },
            { reps: 3, percentage: 0.90 }
          ]
        },
        # Week 3
        {
          description: "Week 3: 3x1",
          lifts: [
            { reps: 5, percentage: 0.75 },
            { reps: 3, percentage: 0.85 },
            { reps: 1, percentage: 0.95 }
          ]
        },
        # Week 4
        {
          description: "Week 4: Deload 3x5",
          lifts: [
            { reps: 5, percentage: 0.40 },
            { reps: 5, percentage: 0.50 },
            { reps: 5, percentage: 0.60 }
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

  def calculated_total
    @calculated_total ||= begin
      total = []
      if lift_scheme == "manual"
        (sets || 0).times do |set|
          description = duration.present? ? "Hold for #{duration} seconds" : "Perform #{reps} reps"
          total << { reps: reps, description: description }
        end
      else
        current_sequence[:lifts].each do |lift|
          reps = lift[:reps]
          percentage = lift[:percentage]
          calculated_weight = calculate_weight(percentage)
          if weight.nil?
            description = "Perform #{reps} reps"
          else
            description = "Perform #{reps} reps at #{calculate_weight(percentage)} lbs"
          end
          total << { reps: reps, percentage: percentage, description: description, weight: calculated_weight, plates: plates(calculated_weight) }
        end
      end
      total
    end
  end

  def rest_time
    after_lift = rest || scheme&.fetch(:rest, 0)
    during_lift = duration || scheme&.fetch(:duration, 0)
    after_lift.to_i + during_lift.to_i
  end

  def plates(weight)
    return [] if weight.nil?

    remaining_weight = (weight.to_f - BAR_WEIGHT) / 2
    plates = []
    WEIGHT_PLATES.each do |plate|
      while remaining_weight >= plate
        plates << plate
        remaining_weight -= plate
      end
    end
    plates
  end

  private

  ## Rounds calculated weight to the nearest 5 lbs
  def calculate_weight(percentage)
    return nil if weight.nil?

    (weight * percentage / 5).round * 5
  end
end
