# frozen_string_literal: true

require_relative 'modules/validation'
require_relative 'modules/config'
require_relative 'menu/interface'
require_relative 'player'
require_relative 'players/dealer'
require_relative 'card'
require_relative 'hand'
require_relative 'deck'
require_relative 'bank'
require_relative 'game'

Game.new(Interface.new).init
