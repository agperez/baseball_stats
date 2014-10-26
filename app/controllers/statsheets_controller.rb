class StatsheetsController < ApplicationController
  before_action :set_statsheet, only: [:show, :edit, :update, :destroy]

  # GET /statsheets
  # GET /statsheets.json
  def index
    @statsheets = Statsheet.all
  end

  # GET /statsheets/1
  # GET /statsheets/1.json
  def show
  end

  # GET /statsheets/new
  def new
    @statsheet = Statsheet.new
  end

  # GET /statsheets/1/edit
  def edit
  end

  # POST /statsheets
  # POST /statsheets.json
  def create
    @statsheet = Statsheet.new(statsheet_params)

    respond_to do |format|
      if @statsheet.save
        format.html { redirect_to @statsheet, notice: 'Statsheet was successfully created.' }
        format.json { render :show, status: :created, location: @statsheet }
      else
        format.html { render :new }
        format.json { render json: @statsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statsheets/1
  # PATCH/PUT /statsheets/1.json
  def update
    respond_to do |format|
      if @statsheet.update(statsheet_params)
        format.html { redirect_to @statsheet, notice: 'Statsheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @statsheet }
      else
        format.html { render :edit }
        format.json { render json: @statsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statsheets/1
  # DELETE /statsheets/1.json
  def destroy
    @statsheet.destroy
    respond_to do |format|
      format.html { redirect_to statsheets_url, notice: 'Statsheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statsheet
      @statsheet = Statsheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statsheet_params
      params.require(:statsheet).permit(:games, :ab, :runs, :hits, :doubles, :triples, :hr, :rbi, :sb, :cs, :player_id, :team_id, :season_id, :season_stat_id, :league_id)
    end
end
