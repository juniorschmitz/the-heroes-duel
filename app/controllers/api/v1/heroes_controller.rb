module Api
  module V1
    class HeroesController < ApplicationController
      def index
        heroes = Hero.order('created_at DESC');
        heroes.each do |hero|
          hero.upgraded_hero
        end
        render json: { status: 'SUCCESS', message: 'All heroes', data: heroes }, status: :ok
      end

      def show
        hero = Hero.find(params[:id])
        upgraded_hero = hero.upgraded_hero
        render json: { status: 'SUCCESS', message: 'Loaded hero', data: upgraded_hero }, status: :ok
      end

      def get_race
        hero = Hero.find(params[:id])
        render json: { status: 'SUCCESS', message: "Race of the hero #{hero.name}", data: hero.race }, status: :ok
      end

      def create
        hero = Hero.new(hero_params)
        if hero.save
          render json: { status: 'SUCCESS', message: 'Your new hero was saved! :-)', data: hero }, status: :created
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
        if hero.update(hero_params)
          render json: { status: 'SUCCESS', message: 'Your hero has been updated! :-)', data: hero }, status: :ok
        else
          render json: { status: 'ERROR', message: 'We could not update your hero! :-(', data: hero.errors },
                 status: :unprocessable_entity
        end
      end

      private
      def hero_params
        params.permit(:name, :power, :defense, :race_id)
      end
    end
  end
end
