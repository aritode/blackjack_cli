# frozen_string_literal: true

class Deck
  include CardsHelper

  def initialize
    @cards = []
    populate
    shuffle!
  end

  def deal
    @cards.pop if @cards.size.positive?
  end

  private

  def populate
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        card = Card.new(rank, suit)
        @cards << card
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end
