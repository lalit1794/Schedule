class DetailThreesController < ApplicationController
  before_action :set_detail_three, only: [:show, :edit, :update, :destroy]

  # GET /detail_threes
  # GET /detail_threes.json
  def index
    @detail_threes = DetailThree.all
  end

  # GET /detail_threes/1
  # GET /detail_threes/1.json
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

  # GET /detail_threes/new
  def new
    @detail_three = DetailThree.new
  end

  # GET /detail_threes/1/edit
  def edit
  end

  # POST /detail_threes
  # POST /detail_threes.json
  def create
    @detail_three = DetailThree.new(detail_three_params)

    respond_to do |format|
      if @detail_three.save
        format.html { redirect_to @detail_three, notice: 'Detail three was successfully created.' }
        format.json { render :show, status: :created, location: @detail_three }
      else
        format.html { render :new }
        format.json { render json: @detail_three.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detail_threes/1
  # PATCH/PUT /detail_threes/1.json
  def update
    respond_to do |format|
      if @detail_three.update(detail_three_params)
        format.html { redirect_to @detail_three, notice: 'Detail three was successfully updated.' }
        format.json { render :show, status: :ok, location: @detail_three }
      else
        format.html { render :edit }
        format.json { render json: @detail_three.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detail_threes/1
  # DELETE /detail_threes/1.json
  def destroy
    @detail_three.destroy
    respond_to do |format|
      format.html { redirect_to detail_threes_url, notice: 'Detail three was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detail_three
      @detail_three = DetailThree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detail_three_params
      params.require(:detail_three).permit(:loan, :term, :rate, :disburse_date, :pay_strt_date)
    end
end
