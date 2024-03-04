class CreateMovieInBulkJob
  include Sidekiq::Job
  require "json"

  def perform(movies_params)
    movies_params = JSON.parse(movies_params)
    movies_to_import = []

    movies_params.each do |movie_params|
      movies_to_import << Movie.new(title: movie_params["title"], director: movie_params["director"])
    end

    Movie.import movies_to_import
  end
end
