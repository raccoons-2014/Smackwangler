require 'rails_helper'


describe 'GameEngine::GameRunner' do
  describe '#resolve_round' do
    before(:each) do
      game_db_model = create(:game)
      game_db_model.player_one.deck = create(:deck)
      game_db_model.player_two.deck = create(:deck)

      @game_state = GameEngine::GameState.new(game_db_model)

      @winning_card = GameEngine::Card.new(create :strong_card)
      @losing_card = GameEngine::Card.new(create :weak_card)
      @starting_points = GameEngine::GAME_RULES[:starting_points]

    end

    # ----------
    #additional tests could be written to test the reset to [] for other initial conditions
    it 'should reset the players selections to [] when played cards for each is nil' do
      @game_state.player_one.selection[0] = nil
      @game_state.player_two.selection[0] = nil
      GameEngine::GameRunner.resolve_round(@game_state)
      expect(@game_state.player_one.selection).to eq []
      expect(@game_state.player_two.selection).to eq []
    end
    #-------------

    it 'should deduct the correct number of points from the losing player and add them to the winning player' do
      @game_state.player_one.selection << @winning_card
      @game_state.player_two.selection << @losing_card
      damage = (@winning_card.max_stat - @losing_card.max_stat)
      GameEngine::GameRunner.resolve_round(@game_state)
      expect(@game_state.player_two.points).to eq @starting_points - damage
      expect(@game_state.player_one.points).to eq @starting_points + damage
    end

    it 'should not deduct any points when both players chose to play no cards' do
      @game_state.player_one.selection << nil
      @game_state.player_two.selection << nil
      GameEngine::GameRunner.resolve_round(@game_state)
      expect(@game_state.player_two.points).to eq @starting_points
      expect(@game_state.player_one.points).to eq @starting_points
    end

    it 'should correctly assign points when player one does not play a card but the other player does' do
      @game_state.player_one.selection << nil
      @game_state.player_two.selection << @winning_card
      GameEngine::GameRunner.resolve_round(@game_state)
      expect(@game_state.player_one.points).to eq @starting_points - @winning_card.max_stat
      expect(@game_state.player_two.points).to eq @starting_points + @winning_card.max_stat
    end

    it 'should correctly assign points when player two does not play a card but the other player does' do
      @game_state.player_one.selection << @winning_card
      @game_state.player_two.selection << nil
      GameEngine::GameRunner.resolve_round(@game_state)
      expect(@game_state.player_two.points).to eq @starting_points - @winning_card.max_stat
      expect(@game_state.player_one.points).to eq @starting_points + @winning_card.max_stat
    end
  end
end
