# frozen_string_literal: true

require_relative 'modules/validation'

class Player
  include Validation
  validate :name, :presence

  attr_reader :bank, :name, :hand

  def initialize(name)
    @name = name
    @bank = Config::INITIAL_BANK
    validate!
  end

  def make_bet(amount)
    @bank -= amount if @bank >= amount
  end

  def take_money(amount)
    @bank += amount
  end
end
