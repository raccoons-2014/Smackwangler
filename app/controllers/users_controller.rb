class UsersController < ApplicationController
  include SessionHelper

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.create_deck(name:"Your Deck").cards.push(Card.where("id <= 30"))
      login(@user)
      redirect_to profile_path
    else
      flash[:error] = @user.errors.full_messages.join(", ")
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find params[:id]
  end

  def profile
    if current_user
      @user = current_user
      @wins = @user.count_wins
      @losses = @user.count_losses
      @ratio = @user.win_loss_ratio
      @last_20_games = @user.last_20_games
    else
      redirect_to root_path
    end
  end



  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end

end
