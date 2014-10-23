class VotesController < ApplicationController

  before_filter :authenticate, only: [:create, :destroy]

  def create
    if params[:vote] == 'true'
      v = Vote.new(user_id: current_user.id, movie_id: params[:movie_id], positive: true)
    else
      v = Vote.new(user_id: current_user.id, movie_id: params[:movie_id], positive: false)
    end
    v.save

    # code for voting with jQuery, so as not to reload the page, when a user votes, but only
    # change the voting section

    # render partial as a string
    votes_html = render_to_string(partial: 'movies/vote_section', locals: { movie: v.movie })

    # return the string created above, as a json response to jQuery to handle.
    render json: {votes: votes_html}
  end

  def destroy
    v = Vote.find(params[:id])
    v.destroy

    votes_html = render_to_string(partial: 'movies/vote_section', locals: { movie: v.movie })

    render json: {votes: votes_html}
  end
end
