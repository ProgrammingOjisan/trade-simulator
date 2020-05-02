class FavoritesController < ApplicationController
before_action :require_user_logged_in

  def create
    condition = Condition.find(params[:condition_id])
    if current_user.favorite(condition)
      flash[:success] = "added to your favorites"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "failed"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    condition = Condition.find(params[:condition_id])
    if current_user.unfavorite(condition)
      flash[:success] = "removed from your favorites"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "failed"
      redirect_back(fallback_location: root_path)
    end
  end

end
