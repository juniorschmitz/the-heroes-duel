require 'swagger_helper'

RSpec.describe 'api/v1/heroes', type: :request do
  path '/api/v1/heroes' do
    Hero.destroy_all
    Race.destroy_all

    get('list heroes') do
      tags "Heroes"
      description 'Lists all heroes that are already registered.'
      consumes 'application/json'
      produces 'application/json'
      races = Race.create([{ name: "orcs", buff_type: "defense", buff_quantity: 990 }, { name: "humans", buff_type: "power", buff_quantity: 900 }])
      Hero.create([ { name: "Aragorn II", power: 1000, defense: 500, race_id: races.first.id }, { name: "Lurtz", power: 900, defense: 350, race_id: races.last.id }])
      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :array,
              items: {
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  created_at: { type: :string },
                  updated_at: { type: :string },
                  power: { type: :string },
                  defense: { type: :integer }
                }
              }
            }
          }
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

    post('create hero') do
      tags "Heroes"
      description 'Creates a new hero. The hero contains name (ex: aragorn, legolas, salron, etc), a power (that mus be between 1 and 1000), and the defense (that must be between 0 and 1000), also, every hero should belong to a race, so you must provide the race_id.'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :hero, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          power: { type: :integer },
          defense: { type: :integer },
          race_id: { type: :integer }
        },
        required: [ 'name', 'power', 'defense', 'race_id' ]
      }

      response(201, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            }
          }
        race = Race.create({ name: "humans", buff_type: "power", buff_quantity: 900 })
        let(:hero) { { name: 'Faramir', power: 600, defense: 550, race_id: race.id } }
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

  path '/api/v1/heroes/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show one hero') do
      tags "Heroes"
      description 'Gets a specific hero by id.'
      consumes 'application/json'
      produces 'application/json'
      created_race = Race.create({ name: "elves", buff_type: "power", buff_quantity: 1000 })
      created_hero = Hero.create({ name: "Legolas", power: 1000, defense: 900, race_id: created_race.id })
      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            }
          }
        let(:id) { created_hero.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['name']).to eql 'Legolas'
        end
      end

      response(404, 'hero not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update hero') do
      tags "Heroes"
      description 'Updates a specific race.'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :hero, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          power: { type: :integer },
          defense: { type: :integer },
          race_id: { type: :integer }
        },
        required: [ 'name', 'power', 'defense', 'race_id' ]
      }
      created_race = Race.create({ name: "evilmen", buff_type: "power", buff_quantity: 1000 })
      created_hero = Hero.create({ name: "Witch King", power: 1000, defense: 1000, race_id: created_race.id })
      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            }
          }
        let(:id) { created_hero.id }
        let(:hero) { { name: 'Witch Prince', power: 900, defense: 900 } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['name']).to eql 'Witch Prince'
          expect(data['data']['power']).to eql 900
          expect(data['data']['defense']).to eql 900
        end
      end

      response(404, 'hero not found') do
        let(:id) { 'invalid' }
        let(:hero) { { name: 'Witch Prince', power: 900, defense: 900 } }
        run_test!
      end
    end

    delete('delete hero') do
      tags "Heroes"
      description 'Deletes a specific hero'
      consumes 'application/json'
      produces 'application/json'
      created_race = Race.create({ name: "evilmen", buff_type: "power", buff_quantity: 1000 })
      created_hero = Hero.create({ name: "Witch King", power: 1000, defense: 1000, race_id: created_race.id })
      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string },
                power: { type: :string },
                defense: { type: :integer }
              }
            }
          }
        let(:id) { created_hero.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eql 'Your hero has been deleted!'
        end
      end

      response(404, 'race not found') do
        schema type: :object,
          properties: {
            message: { type: :string }
          }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/heroes/{id}/get_race' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get_race hero') do
      tags "Heroes"
      description 'Gets the race of the specified hero.'
      consumes 'application/json'
      produces 'application/json'
      created_race = Race.create({ name: "wizards", buff_type: "power", buff_quantity: 1000 })
      created_hero = Hero.create({ name: "Gandalf", power: 1000, defense: 1000, race_id: created_race.id })
      response(200, 'successful') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { 
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string },
                buff_type: { type: :string },
                buff_quantity: { type: :integer }
              }
            }
          }
        let(:id) { created_hero.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eql "Race of the hero #{created_hero.name}"
        end
      end

      response(404, 'race not found') do
        schema type: :object,
          properties: {
            message: { type: :string }
          }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
