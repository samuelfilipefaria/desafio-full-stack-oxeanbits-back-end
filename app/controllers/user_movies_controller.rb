class UserMoviesController < ApplicationController
  before_action :authorize_request

  def create
    @user_movie = UserMovie.new(
      user_id: user_id_by_token,
      movie_id: params[:movie_id],
      score: params[:score],
    )

    if @user_movie.save
      render json: {notice: "Movie score was successfully created."}, status: 200
    else
      render json: {error: "Error creating movie score!"}, status: 400
    end
  end

  def update
    @user_movie = UserMovie.where("user_id = ? AND movie_id = ?", user_id_by_token, params[:id])

    render json: {error: "Error finding movie score!"}, status: 400 unless @user_movie

    if  @user_movie.update(score: params[:score])
      render json: {notice: "Movie score was successfully updated."}, status: 200
    else
      render json: {error: "Error updating movie score!"}, status: 400
    end
  end
end
