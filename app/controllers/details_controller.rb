class DetailsController < ApplicationController
  before_action :set_detail, only: [:show, :edit, :update, :destroy]

  # GET /details
  # GET /details.json
  def index
    @details = Detail.all
  end

  # GET /details/1
  # GET /details/1.json
  def show
    @date = @detail.pay_strt_date-1.month
  
    @end_balance = @detail.loan
    @rate_per_period = @detail.rate / (100 * @detail.term)
    @period = @detail.term
    @dte, @pb, @pp, @intp, @tp, @eb  = [], [], [], [], [], []
    for i in 1..(@detail.term) do
      @pb.push(@prev_balance = (@end_balance).round(2))
      @dte.push(@date = @date+1.month)
      @intp.push(@intrst = (@prev_balance * @rate_per_period).round(2))
      @tp.push(@total_pay =  (@prev_balance * ((@rate_per_period*((1+@rate_per_period)**@period)) / (((1+@rate_per_period)**@period) - 1))).round(2))
      @pp.push(@princpl_pay = (@total_pay - @intrst).round(2))
      @eb.push(@end_balance = (@prev_balance - @princpl_pay).round(2))
      @period = @period - 1

    end
  end

  # GET /details/new
  def new
    @detail = Detail.new
  end

  # GET /details/1/edit
  def edit
  end

  # POST /details
  # POST /details.json
  def create
    @detail = Detail.new(detail_params)

    respond_to do |format|
      if @detail.save
        format.html { redirect_to @detail, notice: 'Detail was successfully created.' }
        format.json { render :show, status: :created, location: @detail }
      else
        format.html { render :new }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /details/1
  # PATCH/PUT /details/1.json
  def update
    respond_to do |format|
      if @detail.update(detail_params)
        format.html { redirect_to @detail, notice: 'Detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @detail }
      else
        format.html { render :edit }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /details/1
  # DELETE /details/1.json
  def destroy
    @detail.destroy
    respond_to do |format|
      format.html { redirect_to details_url, notice: 'Detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detail
      @detail = Detail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detail_params
      params.require(:detail).permit(:loan, :term, :rate, :disburse_date, :pay_strt_date)
    end
end
