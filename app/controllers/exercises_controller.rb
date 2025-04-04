class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit update destroy ]

  # GET /exercises or /exercises.json
  def index
    @categories = Category.order(:order)
    @exercises = Exercise.includes(:category).all
  end

  # GET /exercises/1 or /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new
  end

  # GET /exercises/1/edit
  def edit
  end

  # POST /exercises or /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)

    respond_to do |format|
      if @exercise.save
        format.html { redirect_to exercises_path, notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercises/1 or /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.html { redirect_to exercises_path, notice: "Exercise was successfully updated." }
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1 or /exercises/1.json
  def destroy
    @exercise.destroy!

    respond_to do |format|
      format.html { redirect_to exercises_path, status: :see_other, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def complete
    @exercise = Exercise.find(params[:exercise_id])
    if progress_weight?
      @exercise.update!(weight: @exercise.weight + @exercise.progression)
    end

    begin
      ExerciseHistory.create!(
        exercise: @exercise,
        sequence_position: completed_sequence_position || 0,
        weight: weight,
        success: true,
        sets: sets,
        reps: reps
      )

      redirect_to root_path, notice: "Exercise completed successfully!"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to root_path, alert: "Failed to save: #{e.record.errors.full_messages.join(', ')}"
    rescue => e
      redirect_to root_path, alert: "An error occurred: #{e.message}"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params.expect(:id))
  end

  def completed_sequence_position
    return unless sequence

    @completed_sequence_position ||= begin
      current = @exercise.exercise_histories.last&.sequence_position || 0
      (current + 1) % sequence.length
    end
  end

  def progress_weight?
    return false unless sequence && @exercise.weight&.positive? && @exercise.progression&.positive?

    completed_sequence_position == 0
  end

  def sequence
    return unless scheme && scheme[:sequence].present?

    scheme[:sequence]
  end

  def scheme
    return unless @exercise.lift_scheme.present? && @exercise.lift_scheme != "manual"

    @scheme ||= ExerciseSchemes::SCHEMES[@exercise.lift_scheme.to_sym]
  end

  def sequence_position
    return unless sequence

    @sequence_position ||= begin
      current = @exercise.exercise_histories.last&.sequence_position || 0
      (current + 1) % sequence.length
    end
  end

  def sets
    @exercise.sets || @exercise.calculated_total&.length || 0
  end

  def reps
    @exercise.reps || @exercise.calculated_total&.last&.[](:reps) || 0
  end

  def weight
    @exercise.calculated_total&.last&.[](:weight) || 0
  end

  # Only allow a list of trusted parameters through.
  def exercise_params
    params.require(:exercise).permit(:name, :image, :link, :category_id, :lift_scheme, :weight, :progression, :duration, :reps, :sets, :rest, :description)
  end
end
