require 'swagger_helper'

RSpec.describe 'api/v1/duel', type: :request do
  path '/api/v1/duel/fight' do

    post('fight duel') do
      tags "Duels"
      consumes 'application/json'
      produces 'application/json'
      parameter name: :duel, in: :body, schema: {
        type: :object,
        properties: {
          id_hero_1: { type: :integer },
          id_hero_2: { type: :integer }
        },
        required: [ 'id_hero_1', 'id_hero_2' ]
      }

      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            about_fight: { type: :string },
            winner: {
              type: :object,
              properties: {
                name: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            },
            loser: {
              type: :object,
              properties: {
                name: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            }
          }
        let(:duel) { {id_hero_1: 1, id_hero_2: 2} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!        
      end
    end
  end
end