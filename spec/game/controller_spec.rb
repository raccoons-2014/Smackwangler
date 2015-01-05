require 'rails_helper'
require 'spec_helper'

describe 'GameEngine::Controller' do
  describe '#advance_game' do
    before(:each) do
      @game_db_model = create(:game)
      @game_db_model.player_one.deck = create(:deck)
      @game_db_model.player_two.deck = create(:deck)

      game = GameEngine::Game.new(@game_db_model)
      @game_setup = game.dup; @game_setup.phase = :setup
      @game_move = game.dup; @game_move.phase = :move
      @game_resolution = game.dup; @game_resolution.phase = :resolution

    end

    xit 'should be in setup phase if it is not time for move phase' do
      @game_setup.time = Time.now
      GameEngine::Cache.save_game_state(@game_setup)
      expect(GameEngine::Controller.advance_game(@game_db_model, @game_setup.player_one.id)[:phase]).to eq :setup
    end

    xit 'should proceed to move phase if time is over the alloted setup time' do
      @game_setup.time = Time.now - GameEngine::GAME_RULES[:setup_time]
      GameEngine::Cache.save_game_state(@game_setup)
      expect(GameEngine::Controller.advance_game(@game_db_model, @game_setup.player_one.id)[:phase]).to eq :move
    end

    xit 'should be in move phase if it is not time for resolution phase' do
      @game_move.time = Time.now
      GameEngine::Cache.save_game_state(@game_move)
      expect(GameEngine::Controller.advance_game(@game_db_model, @game_move.player_one.id)[:phase]).to eq :move
    end

    xit "should set player one's choice to nil if no choice is made and their request is recieved past alloted move time" do
      @game_move.time = Time.now - GameEngine::GAME_RULES[:move_time]
      GameEngine::Cache.save_game_state(@game_move)
      GameEngine::Controller.advance_game(@game_db_model, @game_move.player_one.id)
      expect(GameEngine::Cache.fetch_game_state(@game_db_model).player_one.selection).to eq [nil]
      expect(GameEngine::Cache.fetch_game_state(@game_db_model).player_two.selection).to eq []
    end

    xit 'should set both choices to nil if it is time to proceed to resolution phase' do
      @game_move.time = Time.now - GameEngine::GAME_RULES[:move_time]
      GameEngine::Cache.save_game_state(@game_move)
      GameEngine::Controller.advance_game(@game_db_model, @game_move.player_one.id)
      GameEngine::Controller.advance_game(@game_db_model, @game_move.player_two.id)
      expect(GameEngine::Cache.fetch_game_state(@game_db_model).player_one.selection).to eq [nil]
      expect(GameEngine::Cache.fetch_game_state(@game_db_model).player_two.selection).to eq [nil]
    end

    xit "should proceed to the resolution phase if both choices have been made" do
      @game_move.time = Time.now - GameEngine::GAME_RULES[:move_time]
      GameEngine::Cache.save_game_state(@game_move)
      GameEngine::Controller.advance_game(@game_db_model, @game_move.player_one.id)
      GameEngine::Controller.advance_game(@game_db_model, @game_move.player_two.id)
      expect(GameEngine::Cache.fetch_game_state(@game_db_model).phase).to eq :resolution
    end
  end
end
