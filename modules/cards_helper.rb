# frozen_string_literal: true

module CardsHelper
  def add(card)
    @cards ||= []
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
end
