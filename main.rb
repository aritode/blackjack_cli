require_relative 'modules/cards/suit'
require_relative 'modules/cards/rank'
require_relative 'card'
require_relative 'hand'
require_relative 'deck'

# c1 = Card.new(Rank::ACE, Suit::HEARTS)
# c2 = Card.new(Rank::JACK, Suit::HEARTS)
# c3 = Card.new(Rank::DEUCE, Suit::SPADES)
#
# c2.flip_card
#
# puts "c1 = #{c1}"
# puts "c2 = #{c2}"
# puts "c3 = #{c3}"
#
# # c1.flip_card
#
# def check_rank(c1, c2)
#   if c1.rank > c2.rank
#     puts "#{c1} is greater than #{c2}"
#   elsif c1.rank < c2.rank
#     puts "#{c1} is not greater than #{c2}"
#   else
#     puts "#{c1} has equal value as #{c2}"
#   end
# end
#
# def check_suit(c1, c2)
#   if c1.suit == c2.suit
#     puts "#{c1} has the same suit as #{c2}"
#   else
#     puts "#{c1} has different suit than #{c2}"
#   end
# end
#
# check_rank(c1, c2)
#
# check_suit(c1, c2)
# check_suit(c1, c3)
#
#
# # Create a Hand
#
# h1 = Hand.new
# h2 = Hand.new
#
# h1.add(c1)
# h1.add(c2)
#
# puts "\nHand 1:"
# puts h1.show_hand
# puts "\nHand 2:"
# puts h2.show_hand
#
# puts "\nHand 1 is giving Hand 2 - #{c1} card"
# puts "----------------"
# h1.give(c1, h2)
#
# puts "\nHand 1:"
# puts h1.show_hand
# puts "\nHand 2:"
# puts h2.show_hand
#
# puts "\nClearing Hand 1:"
# puts "----------------"
# h1.clear
#
# puts "\nHand 1:"
# puts h1.show_hand
# puts "\nHand 2:"
# puts h2.show_hand

# Create a Deck

# d1 = Deck.new
# d1.populate
#
# puts "\nCreating a Deck:"
# puts "----------------"
# puts
#
# puts d1.show_hand
#
# puts "\nShuffling a Deck:"
# puts "----------------"
# puts
#
# d1.shuffle!
#
# puts d1.show_hand

require_relative 'game'

Game.new
