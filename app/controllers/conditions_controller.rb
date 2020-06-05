class ConditionsController < ApplicationController

  def index
    @stocks = Stock.all
    @conditions = Condition.order(id: :desc).page(params[:page]).per(9)
  end

  def show
    set_form_datalist
    @condition = Condition.find(params[:id])
    @results = trade_simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)
    @preview_mode = true
  end

  def new
    set_form_datalist
    @condition = Condition.new(stock_id:1, buy_condition: -0.01, sell_condition: 0.005, duration: 10)
  end

  def create
    set_form_datalist
    existing_condition = Condition.find_by(stock_id: params[:condition][:stock_id], buy_condition: params[:condition][:buy_condition], sell_condition: params[:condition][:sell_condition], duration: params[:condition][:duration])
    if existing_condition.present?
      @condition = existing_condition
    else
      @condition = Condition.new(condition_params)
    end
    @results = trade_simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)

    if @results.include? "Error"
            flash.now[:danger] = @results
            render :new
    elsif params[:preview]
        @preview_mode = true
        render :new
    else
        @condition.interest = @results[2][0] if @results
        if @condition.save
            flash[:success] = "saved"
            redirect_to conditions_url
        else
            flash.now[:danger] = "failed"
            render :new
        end
    end
        
  end

  def update
    create
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