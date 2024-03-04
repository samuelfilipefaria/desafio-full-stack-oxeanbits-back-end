class ApplicationController < ActionController::API
  def authorize_request
    begin
      render json: {error: "Error finding user!"}, status: 400 unless User.find(user_id_by_token)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def generate_new_token(user_id, username)
    token = JsonWebToken.encode(user_id: user_id)
    time = Time.now + 24.hours.to_i
    render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: username }, status: :ok
  end

  def user_id_by_token
    decoded = JsonWebToken.decode(token)
    decoded[:user_id]
  end

  def token
    request.headers['Authorization']&.split(' ').last
  end
end
