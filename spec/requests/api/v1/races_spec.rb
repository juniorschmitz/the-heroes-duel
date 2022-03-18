require 'swagger_helper'

RSpec.describe 'api/v1/races', type: :request do
  path '/api/v1/races' do
    Hero.destroy_all
    Race.destroy_all

    get('list races') do
      tags "Races"
      Race.create([{ name: "orcs", buff_type: "defense", buff_quantity: 990 }, { name: "humans", buff_type: "power", buff_quantity: 900 }])
      consumes 'application/json'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to be > 1
        end
      end
    end

    post('create race') do
      tags "Races"
      consumes 'application/json'
      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          buff_type: { type: :string },
          buff_quantity: { type: :string }
        },
        required: [ 'name', 'buff_type', 'buff_quantity' ]
      }

      response(201, 'successful') do
        let(:race) { { name: 'hobbits', buff_type: 'defense', buff_quantity: '500' } }
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

  path '/api/v1/races/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show one race') do
      tags "Races"
      created_race = Race.create({ name: "elves", buff_type: "power", buff_quantity: 1000 })
      response(200, 'successful') do
        let(:id) { created_race.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['name']).to eql 'elves'
        end
      end

      response(404, 'race not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update race') do
      tags "Races"
      created_race = Race.create({ name: "evilmen", buff_type: "power", buff_quantity: 1000 })
      consumes 'application/json'
      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          buff_type: { type: :string },
          buff_quantity: { type: :string }
        },
        required: [ 'name', 'buff_type', 'buff_quantity' ]
      }
      response(200, 'successful') do
        let(:id) { created_race.id }
        let(:race) { { name: 'evilmen', buff_type: 'defense', buff_quantity: 600 } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['name']).to eql 'evilmen'
          expect(data['data']['buff_type']).to eql 'defense'
          expect(data['data']['buff_quantity']).to eql 600
        end
      end

      response(404, 'race not found') do
        let(:id) { 'invalid' }
        let(:race) { { name: 'evilmen', buff_type: 'defense', buff_quantity: 1000 } }
        run_test!
      end
    end

    delete('delete race') do
      tags "Races"
      created_race = Race.create({ name: "undead", buff_type: "power", buff_quantity: 1000 })
      response(200, 'successful') do
        let(:id) { created_race.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eql 'Your race has been deleted!'
        end
      end

      response(404, 'race not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/races/{id}/get_heroes' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get_heroes race') do
      tags "Races"
      created_race = Race.create({ name: "wizards", buff_type: "defense", buff_quantity: 1000 })
      Hero.create(name: "Gandalf", power: 1000, defense: 1000, race_id: created_race.id)
      response(200, 'successful') do
        let(:id) { created_race.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eql "All heroes in the race #{created_race.name}"
        end
      end

      response(404, 'race not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
