class DecksController < ApplicationController
# Make an instance of the deck class at the beginning of each game
# shuffle that deck once before play
# to draw a card, pop off of that deck


#Make a method to replenish the hand to have 6 cards at the beginning of each turn
  # @player_1 = User.find(1)
  # @player_2 = User.find(2)
  def shuffle_all
    @all_cards = HeroCard.all.shuffle
    @original_shuffled_deck = @all_cards.dup
  end

  def prepare_players_decks
    @user1 = User.find(session[:user1_id])
    @user2 = User.find(session[:user2_id])

    @deck1 = Deck.create(user: @user1)
    @deck2 = Deck.create(user: @user2)

    15.times do
      DeckCardRelationship.create(hero_card: @all_cards.pop, deck: @deck1)
    end

    15.times do
      DeckCardRelationship.create(hero_card: @all_cards.pop, deck: @deck2)
    end

    # deck = Deck.find(player.id)
    # deck = Deck.find(user: player)
    # deck = deck.shuffle
  end

  def deck1
    @deck1 = HeroCard.all.shuffle[1..15]
    render :json => @deck1.to_json
  end

  def deck2
    @deck2 = HeroCard.all.shuffle[1..15]
    render :json => @deck2.to_json
  end


end
