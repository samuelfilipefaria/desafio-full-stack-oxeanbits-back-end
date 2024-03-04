class RatingMovieInBulkJob
  include Sidekiq::Job
  require "json"

  def perform(rating_params, user_id)
    rating_params = JSON.parse(rating_params)

    rating_params.each do |rate_params|
      user_movie = UserMovie.find_by(user_id: user_id, movie_id: rate_params["movie_id"])

      if user_movie
        user_movie.update(score: rate_params["score"])
      else
        UserMovie.create(
          user_id: user_id,
          movie_id: rate_params["movie_id"],
          score: rate_params["score"],
        )
      end
    end
  end
end
