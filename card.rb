# frozen_string_literal: true

class Card
  attr_reader :rank

  RANKS = [{ value: 1, name: 'Ace', short_name: 'A' }.freeze,
           { value: 2, name: 'Deuce', short_name: '2' }.freeze,
           { value: 3, name: 'Three', short_name: '3' }.freeze,
           { value: 4, name: 'Four', short_name: '4' }.freeze,
           { value: 5, name: 'Five', short_name: '5' }.freeze,
           { value: 6, name: 'Six', short_name: '6' }.freeze,
           { value: 7, name: 'Seven', short_name: '7' }.freeze,
           { value: 8, name: 'Eight', short_name: '8' }.freeze,
           { value: 9, name: 'Nine', short_name: '9' }.freeze,
           { value: 10, name: 'Ten', short_name: '10' }.freeze,
           { value: 10, name: 'Jack', short_name: 'J' }.freeze,
           { value: 10, name: 'Queen', short_name: 'Q' }.freeze,
           { value: 10, name: 'King', short_name: 'K' }.freeze].freeze

  SUITS = [{ name: 'Hearts', unicode: "\u2665" },
           { name: 'Spades', unicode: "\u2660" },
           { name: 'Diamonds', unicode: "\u2666" },
           { name: 'Clubs', unicode: "\u2663" }].freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    validate!
    @face_up = false
  end

  def face_up?
    @face_up
  end

  def flip_card
    @face_up = !@face_up
  end

  def to_s
    case Config::SHORT_NAME_WITH_UNICODE
    when 1
      face_up? ? "#{@rank[:short_name]} #{@suit[:unicode]}" : '***'
    when 2
      face_up? ? "#{@rank[:name]} of #{@suit[:name]}" : '*** (Face Down) ***'
    else
      'Error: Must use Config::SHORT_NAME_WITH_UNICODE with 1 or 2 (read config.rb)'
    end
  end

  private

  def validate!
    message = 'Suit Hash must be only from Card::SUITS'
    raise message unless SUITS.include? @suit

    message = 'Rank Hash must be only from Card::RANKS'
    raise message unless RANKS.include? @rank
  end
end
