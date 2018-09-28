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

  def give(card, hand)
    if @cards.include?(card)
      @cards.delete(card)
      hand.add(card)
      true
    else
      false
    end
  end

  # Show total points if All cards are face up
  def show_hand
    string = ''
    face_up_counter = 0

    @cards.each do |card|
      string += "#{card}\n"
      face_up_counter += 1 unless card.face_up?
    end

    string += "Total points = #{total_points}\n" if face_up_counter.zero?
    string
  end

  # Getting total points (any Aces by default will be 1)
  def total_points
    points_counter = 0
    ace_counter = 0

    @cards.each do |card|
      points_counter += card.rank
      ace_counter += 1 if card.rank_name == Rank::ACE[:name]

      # Add 10 (Ace already have 1 point)
      points_counter += 10 if ace_counter.positive? && points_counter <= 11
    end

    points_counter
  end

  def flip_cards
    @cards.each(&:flip_card)
  end

  def first_card
    @cards.first
  end
end
