class ConditionsController < ApplicationController

  def index
    @conditions = Condition.order(id: :desc).page(params[:page]).per(9)
  end
  
  def ranking
    @conditions = Condition.order(interest: :desc, duration: :desc).first(20)
  end

  def show
    set_form_datalist
    @condition = Condition.find(params[:id])
    @ticker_symbol = Stock.find(@condition.stock_id).code
    @results = trade_simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)
    @show_result = true
  end

  def new
    set_form_datalist
    @condition = Condition.new(stock_id:1, buy_condition: -0.01, sell_condition: 0.005, duration: 20)
  end
  
  def create
    set_form_datalist
    @condition = Condition.find_or_create_by(condition_params)
    @results = trade_simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)

    if @results.include? "Error"
            flash.now[:danger] = @results
            render :new
    else
      @show_result = true
      @condition.interest = @results[2][0] if @results
      @ticker_symbol = Stock.find(@condition.stock_id).code
      render :new
    end
  end
  
  private
  
  def condition_params
    params.require(:condition).permit(:stock_id, :buy_condition, :sell_condition, :duration)
  end

  def set_form_datalist
    @condition_datalist = []
    (-50..50).reverse_each do |value|
      next if value == 0
      value = (value * 0.1).round(1)
      if value > 0
        @condition_datalist << ["＋#{value}%", (value / 100).round(3)]
      else
        @condition_datalist << ["－#{value.abs}%", (value / 100).round(3)]
      end
    end
  end
end