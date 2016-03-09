class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def myupdate
  end
  
  def myupdated
    @movie = Movie.find_by(title: params[:movie][:oldtitle])
    if @movie == nil 
      flash[:notice] = "#{params[:movie][:oldtitle]} does not exist."
      redirect_to movies_path
    else
      @movie.update_attributes!(movie_params.reject{|k,v| v.blank?})
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  end
  
  def mydelete
  end
  
  def mydeleted
    if params[:movie][:tor] == 'title'
      @movie = Movie.where(title: params[:movie][:here])
    elsif params[:movie][:tor] == 'rating'
      @movie = Movie.where(rating: params[:movie][:here])
    else 
      flash[:notice] = "Either enter the word 'title' or 'rating' in the first box"
      redirect_to movies_path
      return
    end
    if @movie == []
      flash[:notice] = "Movies not found"
    else
      @movie.destroy_all
      flash[:notice] = "Deleted successfully"
    end
    redirect_to movies_path
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings= Movie.all_ratings
    @checked = @all_ratings
    @color= params[:sort_by]
    if params[:sort_by] == "title"  || params[:sort_by] == "release_date"
      session[:sort_by] = params[:sort_by]
      @movies = Movie.order(params[:sort_by])
    else
      @color = session[:sort_by]
      @movies = Movie.order(session[:sort_by])
    end
    
    if params[:ratings]!=nil
      @checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]!= nil
      @checked = session[:ratings].keys
    end
    
    @movies = @movies.where(rating: @checked)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
