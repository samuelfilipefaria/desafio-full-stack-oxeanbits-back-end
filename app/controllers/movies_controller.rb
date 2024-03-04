class MoviesController < ApplicationController
  before_action :authorize_request

  def index
    @movies = Movie.all
    render json: @movies.to_json(methods: :average_score)
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: {notice: "Movie was successfully created."}, status: 200
    else
      render json: {error: "Error creating movie!"}, status: 400
    end
  end

  def bulk_create
    CreateMovieInBulkJob.perform_async(params[:movies_params].to_json)
  end

  def bulk_rating
    RatingMovieInBulkJob.perform_async(params[:rating_params].to_json, user_id_by_token)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :director)
  end
end
