class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = params[:order]
    if params[:order] =='title'
      @title_header = 'hilite'
    elsif params[:order] =='release_date'
      @release_date_header = 'hilite'
    else @movies = Movie.all
    end

    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || nil

    if @selected_ratings == nil
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    sort = params[:order] || session[:order]
    
    if params[:order] != session[:order]
      session[:order] = sort
      flash.keep
      redirect_to :order => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != nil
      session[:order] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys,:order => @order)
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
