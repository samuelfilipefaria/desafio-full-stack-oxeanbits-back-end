class ApplicationController < ActionController::API
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JsonWebToken.decode(header)
      current_user = User.find(decoded[:user_id])
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
end
