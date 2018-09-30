# frozen_string_literal: true

class Card
  attr_reader :rank, :rank_name, :suit

  def initialize(rank, suit)
    @rank = rank[:value]
    @rank_name = rank[:name]
    @suit = suit
    @face_up = true
  end

  def face_up?
    @face_up
  end

  def flip_card
    @face_up = !@face_up
  end

  def to_s
    if face_up?
      "#{rank_name} of #{suit}"
    else
      '*** (Face Down) ***'
    end
  end
end
