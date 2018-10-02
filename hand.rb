# frozen_string_literal: true

class Hand
  include CardsHelper

  # Show total points if All cards are face up
  def to_s
    face_down_counter = @cards.count { |card| !card.face_up? }
    string = @cards.map(&:to_s).join("\n")
    string += "\nTotal points = #{total_points}\n" if face_down_counter.zero?
    string
  end

  # Getting total points (any Aces by default will be 1)
  def total_points
    ace_counter = @cards.count { |card| card.rank[:value] == 1 }
    points = @cards.map { |card| card.rank[:value] }.sum

    ace_counter.times do
      points += 10 if points + 10 <= 21
    end

    points
  end

  def flip_cards(cards = @cards)
    cards.each(&:flip_card)
  end

  def flip_cards_all_up
    if @cards.reject(&:face_up?).any?
      cards_face_down = @cards.reject(&:face_up?)
      flip_cards(cards_face_down)
    end
  end

  def blackjack?
    total_points == Config::BLACKJACK
  end

  def busted?
    total_points > Config::BLACKJACK
  end

  def not_busted?
    total_points < Config::BLACKJACK
  end
end
