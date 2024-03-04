class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      generate_new_token(user.id, user.username)
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
