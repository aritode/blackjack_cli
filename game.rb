class Game
  # Create a Deck

  deck = Deck.new
  deck.populate
  deck.shuffle!

  # Create our playing hands

  hand_one = Hand.new
  hand_two = Hand.new
  hand_three = Hand.new

  dealer = Hand.new

  hands = [hand_one, hand_two, hand_three]

  # Deal cards to our hands (Array)

  deck.deal(hands, 3)

  # Deal 2 cards to dealer

  deck.deal(dealer, 2)

  # Show the player's hands

  hands.each do |hand|
    hand.flip_cards
    puts
    puts hand.show_hand
  end

  # Flip the dealer's first card

  dealer.first_card.flip_card

  # Show the dealer's cards

  puts "\nDealers Cards: "
  puts dealer.show_hand
end
