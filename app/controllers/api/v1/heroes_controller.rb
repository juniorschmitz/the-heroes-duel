module Api
  module V1
    class HeroesController < ApplicationController
      def index
        heroes = Hero.order('created_at DESC');
        render json: { status: 'SUCCESS', message: 'All heroes', data: heroes }, status: :ok
      end

      def show
        hero = Hero.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded hero', data: hero }, status: :ok
      end

      def create
        hero = Hero.new(hero_params)
        if hero.save
          render json: { status: 'SUCCESS', message: 'Your new hero was saved! :-)', data: hero }, status: :ok
        else
          render json: { status: 'ERROR', message: 'We could not save your new hero! :-(', data: hero.errors },
                 status: :unprocessable_entity
        end
      end

      def destroy
        hero = Hero.find(params[:id])
        hero.destroy
        render json: { status: 'SUCCESS', message: 'Your hero has been deleted!', data: hero }, status: :ok
      end

      def update
        hero = Hero.find(params[:id])
        if hero.update_attributes(article_params)
          render json: { status: 'SUCCESS', message: 'Your hero has been updated! :-)', data: hero }, status: :ok
        else
          render json: { status: 'ERROR', message: 'We could not update your hero! :-(', data: hero.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def hero_params
        params.permit(:title, :body)
      end
    end
  end
end
