# frozen_string_literal: true

class Bank
  BET = Config::BET_AMOUNT

  def initialize
    @bank_total = 0
  end

  def bet(player, dealer)
    player.make_bet(BET)
    dealer.make_bet(BET)
    @bank_total += BET * 2
  end

  def draw(player, dealer)
    player.take_money(BET / 2)
    dealer.take_money(BET / 2)
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
