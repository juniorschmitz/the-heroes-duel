require 'swagger_helper'

RSpec.describe 'api/v1/duel', type: :request do
  path '/api/v1/duel/fight' do

    post('fight duel') do
      tags "Duels"
      consumes 'application/json'
      parameter name: :duel, in: :body, schema: {
        type: :object,
        properties: {
          id_hero_1: { type: :integer },
          id_hero_2: { type: :integer }
        },
        required: [ 'id_hero_1', 'id_hero_2' ]
      }

      puts 'batataaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      response(200, 'successful') do
        let(:duel) { {id_hero_1: 1, id_hero_2: 2} }
        run_test!
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   puts data
        # end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
      end
    end
  end
end