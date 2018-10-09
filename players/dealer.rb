# frozen_string_literal: true

class Dealer < Player
  def initialize
    super('Dealer Joe')
  end

  def flip_cards
    @hand.flip_cards_all_up
  end
end
