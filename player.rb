# frozen_string_literal: true

class Player
  include CardsHelper
  include Validation

  validate :name, :presence

  attr_reader :bank, :name, :hand

  def initialize(name)
    @name = name
    @bank = Config::INITIAL_BANK
    @hand = Hand.new
    validate!
  end

  def make_bet(amount)
    @bank -= amount if @bank >= amount
  end

  def take_money(amount)
    @bank += amount
  end

  def take_card(card)
    @hand.add(card)
  end

  def flip_cards
    @hand.flip_cards
  end

  def first_card
    @hand.first_card
  end

  def last_card
    @hand.last_card
  end

  def score
    @hand.total_points
  end

  def busted?
    @hand.busted?
  end

  def not_busted?
    @hand.not_busted?
  end

  def blackjack?
    @hand.blackjack?
  end

  def clear_hand
    @hand.clear
  end

  def hand_size
    @hand.size
  end
end
