class UsersController < ApplicationController
  before_action :authorize_request

  def create
    @user = User.new(
      username: params[:username],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      admin: false
    )

    if @user.save
      generate_new_token(@user.id, @user.username)
    else
      render json: {error: "Error creating user!"}, status: 400
    end
  end
end
