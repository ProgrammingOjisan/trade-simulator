class ConditionsController < ApplicationController
  def index
    @conditions = Condition.all
  end

  def show
    @condition = Condition.find(params[:id])
    @results = simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)
    @preview_mode = true
  end

  def new
    @condition = Condition.new
  end

  def create
    @condition = Condition.new(condition_params)
    @results = simulation(@condition.stock_id, @condition.buy_condition, @condition.sell_condition, @condition.duration)
    
    if params[:preview]
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

  def destroy
  end
  
  private
  
  def condition_params
    params.require(:condition).permit(:stock_id, :buy_condition, :sell_condition, :duration)
  end

end