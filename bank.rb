# frozen_string_literal: true

class Bank
  def initialize
    @bank_total = 0
  end

  def bet(player, dealer)
    player.make_bet(Config::BET_AMOUNT)
    dealer.make_bet(Config::BET_AMOUNT)
    @bank_total += Config::BET_AMOUNT * 2
  end

  def draw(player, dealer)
    player.take_money(@bank_total / 2)
    dealer.take_money(@bank_total / 2)
    clear
  end

  def win(player)
    player.take_money(@bank_total)
    clear
  end

  def to_s
    "Bank Prize: $#{@bank_total}"
  end

  private

  def clear
    @bank_total = 0
  end
end
