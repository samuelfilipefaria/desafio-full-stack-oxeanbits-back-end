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

  def is_admin
    @user = User.find(user_id_by_token)

    render json: {error: "Error finding user!"}, status: 400 unless @user

    if @user.admin
      render json: {is_admin: "true"}, status: 200
    else
      render json: {is_admin: "false"}, status: 200
    end
  end
end
