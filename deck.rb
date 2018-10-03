# frozen_string_literal: true

class Deck
  include CardsHelper

  def initialize
    populate
    shuffle!
  end

  def deal(player)
    player.take_card(@cards.pop) if @cards.size.positive?
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
