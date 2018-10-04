# frozen_string_literal: true

class Hand
  def initialize
    @cards = []
  end

  def add(card)
    @cards << card
  end

  def clear
    @cards.clear
  end

  def first_card
    @cards.first_card
  end

  def last_card
    @cards.last
  end

  def size
    @cards.size
  end

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
    ace_counter.times { points += 10 if points + 10 <= 21 }
    points
  end

  def flip_cards(cards = @cards)
    cards.each(&:flip_card)
  end

  def flip_cards_all_up
    flip_cards(@cards.reject(&:face_up?)) if @cards.reject(&:face_up?).any?
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
