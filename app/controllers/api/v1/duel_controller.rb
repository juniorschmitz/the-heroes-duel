module Api
  module V1
    class DuelController < ApplicationController
      def fight
        hero1 = Hero.find(duel_params[:id_hero_1]);
        hero2 = Hero.find(duel_params[:id_hero_2]);
        all_power_hero1 = hero1.power + hero1.defense
        all_power_hero2 = hero2.power + hero2.defense
        winner = all_power_hero1 > all_power_hero2 ? hero1 : hero2
        render json: { status: 'SUCCESS', message: 'The winner is', data: winner }, status: :ok
      end

      private
      def duel_params
        params.permit(:id_hero_1, :id_hero_2)
      end
    end
  end
end
