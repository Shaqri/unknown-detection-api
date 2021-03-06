class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_posts = current_user.favorite_posts
    render_json(PostSerializer, @favorite_posts, 200,
                { params: { user_favorites: current_user.favorites } })
  end

  def create
    @favorite = current_user.favorites.build(fav_params)
    if @favorite.save
      render_json(FavoriteSerializer, @favorite, 200)
    else
      render_errors(['Unable to create favorite record'], 422)
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    render json: { message: 'Post deleted from favorites' }, status: 200
  end

  private

  def authenticate_user!
    render_errors(['No current user'], 401) unless current_user
  end

  def fav_params
    params.require(:favorite).permit(:post_id)
  end
end
