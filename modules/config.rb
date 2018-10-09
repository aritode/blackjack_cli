# frozen_string_literal: true

module Config
  # Rules
  BLACKJACK = 21
  DEALER_MAX = 17

  # Initial Flip Card
  # Need Parameter 1 or 2
  #
  # Set to 1 if you want 1 card to be initially with face down
  # Set to 2 if you want 2 cards to be initially with face down
  DEALER_FLIP_CARDS_COUNT = 2

  # Money
  INITIAL_BANK = 100
  BET_AMOUNT = 10

  # Card Name
  # Need Parameter 1 or 2
  #
  # Set to 1 - for Short Names - (K <> (with unicode))
  # Set to 2 - for Long Names - (King of Hearts)
  #
  SHORT_NAME_WITH_UNICODE = 1

  # Max number of Cards in Dealer/Player Hands
  # Need Parameter 3..6
  #
  CARDS_MAX = 3
end
