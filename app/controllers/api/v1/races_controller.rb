module Api
  module V1
    class RacesController < ApplicationController
      def index
        races = Race.order('created_at DESC');
        render json: { status: 'SUCCESS', message: 'All races', data: races }, status: :ok
      end

      def show
        race = Race.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded race', data: race }, status: :ok
      end

      def get_heroes
        race = Race.find(params[:id])
        render json: { status: 'SUCCESS', message: "All heroes in the race #{race.name}", data: race.heroes }, status: :ok
      end

      def create
        race = Race.new(race_params)
        if race.save
          render json: { status: 'SUCCESS', message: 'The new race was saved! :-)', data: race }, status: :created
        else
          render json: { status: 'ERROR', message: 'We could not save the new race! :-(', data: race.errors },
                 status: :unprocessable_entity
        end
      end

      def destroy
        race = Race.find(params[:id])
        if params[:id].to_i != 1 && params[:id].to_i != 2
          if race.heroes.size > 0
            render json: { status: 'ERROR', message: 'If you would like to delete this race, first you should delete these heroes:', heroes: race.heroes }, status: :unprocessable_entity
          else
            race.destroy
            render json: { status: 'SUCCESS', message: 'Your race has been deleted!', data: race }, status: :ok
          end
        else
          render json: { status: 'ERROR', message: 'You cannot delete the primary races(human and orcs)!', data: race }, status: :unprocessable_entity
        end
      end

      def update
        race = Race.find(params[:id])
        if params[:id].to_i != 1 && params[:id].to_i != 2
          if race.update(race_params)
            render json: { status: 'SUCCESS', message: 'The race has been updated! :-)', data: race }, status: :ok
          else
            render json: { status: 'ERROR', message: 'We could not update the race! :-(', data: race.errors },
                  status: :unprocessable_entity
          end
        else
          render json: { status: 'ERROR', message: 'You cannot update the primary races(human and orcs)!', data: race }, status: :unprocessable_entity
        end
      end

      private
      def race_params
        params.permit(:name, :buff_type, :buff_quantity)
      end
    end
  end
end
