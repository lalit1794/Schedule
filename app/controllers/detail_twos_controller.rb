class DetailTwosController < ApplicationController
  before_action :set_detail_two, only: [:show, :edit, :update, :destroy]

  # GET /detail_twos
  # GET /detail_twos.json
  def index
    @detail_twos = DetailTwo.all
  end

  # GET /detail_twos/1
  # GET /detail_twos/1.json
  def show
    @date = @detail_two.pay_strt_date-1.month
  
    @end_balance = @detail_two.loan
    @rate_per_period = @detail_two.rate / (100 * @detail_two.term)
    @period = @detail_two.term
    @dte, @pb, @pp, @intp, @tp, @eb  = [], [], [], [], [], []
    for i in 1..(@detail_two.term) do
      @pb.push(@prev_balance = (@end_balance).round(2))
      @dte.push(@date = @date+1.month)
      @intp.push(@intrst = (@prev_balance * @rate_per_period).round(2))
      @tp.push(@total_pay =  (@prev_balance * ((@rate_per_period*((1+@rate_per_period)**@period)) / (((1+@rate_per_period)**@period) - 1))).round(2))
      @pp.push(@princpl_pay = (@total_pay - @intrst).round(2))
      @eb.push(@end_balance = (@prev_balance - @princpl_pay).round(2))
      @period = @period - 1
    end
  
    if @detail_two.disburse_date.month == 1 || 3 || 5 || 7 || 8 || 10 || 12
      t = -1
    elsif @detail_two.disburse_date.month == 2
      y = @detail_two.disburse_date.year
      t = (y%4==0 && y%100!=0 || y%400==0) ? 1 : 2
    else
      t = 0    
    end

      d = ((@detail_two.pay_strt_date - @detail_two.disburse_date).to_int) + t
      k = @intp[0]
      @intp[0] = ((@intp[0] * d) / 30).round(2)
      @tp[0] = (@tp[0] -k + @intp[0]).round(2)   
    



  end

  # GET /detail_twos/new
  def new
    @detail_two = DetailTwo.new
  end

  # GET /detail_twos/1/edit
  def edit
  end

  # POST /detail_twos
  # POST /detail_twos.json
  def create
    @detail_two = DetailTwo.new(detail_two_params)

    respond_to do |format|
      if @detail_two.save
        format.html { redirect_to @detail_two, notice: 'Detail two was successfully created.' }
        format.json { render :show, status: :created, location: @detail_two }
      else
        format.html { render :new }
        format.json { render json: @detail_two.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detail_twos/1
  # PATCH/PUT /detail_twos/1.json
  def update
    respond_to do |format|
      if @detail_two.update(detail_two_params)
        format.html { redirect_to @detail_two, notice: 'Detail two was successfully updated.' }
        format.json { render :show, status: :ok, location: @detail_two }
      else
        format.html { render :edit }
        format.json { render json: @detail_two.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detail_twos/1
  # DELETE /detail_twos/1.json
  def destroy
    @detail_two.destroy
    respond_to do |format|
      format.html { redirect_to detail_twos_url, notice: 'Detail two was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detail_two
      @detail_two = DetailTwo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detail_two_params
      params.require(:detail_two).permit(:loan, :term, :rate, :disburse_date, :pay_strt_date)
    end
end
