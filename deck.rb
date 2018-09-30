# frozen_string_literal: true

class Deck < Hand
  def initialize
    populate
    shuffle!
  end

  def deal(hands, cards_per_hand)
    deal_single_hand(hands, cards_per_hand) if hands.is_a? Hand
    deal_multiple_hands(hands, cards_per_hand) if hands.is_a? Array
  end

  private

  def deal_single_hand(hand, cards_per_hand)
    cards_per_hand.times do
      give(first_card, hand)
    end
  end

  def deal_multiple_hands(hands, cards_per_hand)
    cards_per_hand.times do
      hands.each do |hand|
        give(first_card, hand)
      end
    end
  end

  def populate
    suits = Suit::MY_ENUM
    ranks = Rank::MY_ENUM

    suits.each do |suit|
      ranks.each do |rank|
        card = Card.new(rank, suit)
        card.flip_card
        add(card)
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end
