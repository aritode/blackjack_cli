# frozen_string_literal: true

class Deck
  include CardsHelper

  def initialize
    populate
    shuffle!
  end

  def deal(player)
    if @cards.size.positive?
      card = @cards.pop
      player.take_card(card)
    end
  end

  private

  def populate
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        card = Card.new(rank, suit)
        add(card)
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end
