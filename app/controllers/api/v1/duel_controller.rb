module Api
  module V1
    class DuelController < ApplicationController
      def fight
        hero1 = Hero.find(duel_params[:id_hero_1]).upgraded_hero
        hero2 = Hero.find(duel_params[:id_hero_2]).upgraded_hero
        hero1.power*=2 if rand(100) < 20
        hero2.power*=2 if rand(100) < 20
        all_power_hero1 = hero1.power + hero1.defense
        all_power_hero2 = hero2.power + hero2.defense
        winner = all_power_hero1 > all_power_hero2 ? hero1 : hero2
        loser = winner.name == hero1.name ? hero2 : hero1
        render json: { status: 'SUCCESS', about_fight: "The fight was beween #{hero1.name} and #{hero2.name}.", winner: winner, loser: loser }, status: :ok
      end

      private
      def duel_params
        params.permit(:id_hero_1, :id_hero_2)
      end
    end
  end
end
