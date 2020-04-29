class ConditionsController < ApplicationController
  def index
    @stocks = Stock.all
    @conditions = Condition.order(id: :desc).page(params[:page]).per(6)
  end

  def show
    set_form_datalist
    @condition = Condition.find(params[:id])
    @results = simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)
    @preview_mode = true
  end

  def new
    set_form_datalist
    @condition = Condition.new(stock_id:1, buy_condition: -0.03, sell_condition: 0.05, duration: 10)
  end

  def create
    set_form_datalist
    @condition = Condition.new(condition_params)
    @results = simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)

    if @results.include? "Error"
            flash.now[:danger] = @results
            render :new
    elsif params[:preview]
        @preview_mode = true
        render :new
    else
        @condition.interest = @results[2] if @results
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
      value *= 0.5
      if value > 0
        @condition_datalist << ["＋#{value}%", (value / 100)]
      else
        @condition_datalist << ["－#{value.abs}%", (value / 100)]
      end
    end
    
    @duration_datalist = [["5営業日",5],["10営業日",10],["30営業日",30],["60営業日",60],["90営業日",90],]

  end
end