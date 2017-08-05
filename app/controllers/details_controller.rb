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
    @period = @detail.term
    @date = @detail.pay_strt_date-1.month
    @rate_per_period = @detail.rate / (100 * @detail.term)
    df = (@rate_per_period*((1+@rate_per_period)**@period)) / (((1+@rate_per_period)**@period) - 1) # df = 1/discount factor
    tpm = @detail.loan * df
    intm = @rate_per_period * @detail.loan
    @dte, @pb, @pp, @intp, @tp, @eb  = [], [], [], [], [], []

    if @detail.disburse_date.month == 1 || 3 || 5 || 7 || 8 || 10 || 12
      t = -1
    elsif @detail.disburse_date.month == 2
      y = @detail.disburse_date.year
      t = (y%4==0 && y%100!=0 || y%400==0) ? 1 : 2
    else
      t = 0    
    end
    d = ((@detail.pay_strt_date - @detail.disburse_date).to_int) + t
    intd = (intm * d ) / 30
    tpd = tpm - intm + intd
    @tpeq = (tpd + (@detail.term-1)*tpm) / @detail.term

    @prev_balance = @detail.loan
    for i in 1..(@detail.term) do
      @pb.push(@prev_balance.round(2))
      @tp.push(@tpeq.round(2))
      @period = @detail.term - i
      disfac = (@rate_per_period*((1+@rate_per_period)**@period)) / (((1+@rate_per_period)**@period) - 1)
      @eb.push(@end_balance = (@tpeq / disfac).round(2))
      @pp.push(@princpl_pay = (@prev_balance - @end_balance).round(2))
      @intp.push(@intrst = (@tpeq - @princpl_pay).round(2))
      @dte.push(@date = @date+1.month)
      @prev_balance = @end_balance
    end  
  end


  


  def home
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
