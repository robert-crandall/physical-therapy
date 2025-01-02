class ExerciseHistoriesController < ApplicationController
  before_action :set_exercise_history, only: %i[ show edit update destroy ]

  # GET /exercise_histories or /exercise_histories.json
  def index
    @exercise_histories = ExerciseHistory.all
  end

  # GET /exercise_histories/1 or /exercise_histories/1.json
  def show
  end

  # GET /exercise_histories/new
  def new
    @exercise_history = ExerciseHistory.new
  end

  # GET /exercise_histories/1/edit
  def edit
  end

  # POST /exercise_histories or /exercise_histories.json
  def create
    @exercise_history = ExerciseHistory.new(exercise_history_params)

    respond_to do |format|
      if @exercise_history.save
        format.html { redirect_to @exercise_history, notice: "Exercise history was successfully created." }
        format.json { render :show, status: :created, location: @exercise_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_histories/1 or /exercise_histories/1.json
  def update
    respond_to do |format|
      if @exercise_history.update(exercise_history_params)
        format.html { redirect_to @exercise_history, notice: "Exercise history was successfully updated." }
        format.json { render :show, status: :ok, location: @exercise_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_histories/1 or /exercise_histories/1.json
  def destroy
    @exercise_history.destroy!

    respond_to do |format|
      format.html { redirect_to exercise_histories_path, status: :see_other, notice: "Exercise history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_history
      @exercise_history = ExerciseHistory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exercise_history_params
      params.expect(exercise_history: [ :exercise_id, :sets, :reps, :weight, :success ])
    end
end
