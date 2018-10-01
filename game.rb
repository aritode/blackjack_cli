# frozen_string_literal: true

class Game
  def initialize(interface)
    @interface = interface
    @player = create_player
    @dealer = Dealer.new
    @deck = Deck.new
    @bank = Bank.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
  end

  def init
    make_round_bet(@player, @dealer)
    give_two_cards_to_players
    player_choose_step
  end

  private

  def player_choose_step
    loop do
      @interface.show_header_main_menu

      @interface.show_status(@player, @player_hand)
      @interface.show_status(@dealer, @dealer_hand)
      @interface.show_new_line
      @interface.show_info(@bank)

      open_cards if @player_hand.size == 3 && @dealer_hand.size == 3

      @interface.show_display_menu

      user_choice = gets.to_i
      finish_game if user_choice.zero?

      check_user_input(user_choice)
    end
  end

  def check_user_input(user_choice)
    case user_choice
    when 1
      stand  # skip turn
    when 2
      hit    # add card
    when 3
      open_cards
    else
      player_choose_step
    end
  end

  ##############################################################

  def create_player
    user_name = @interface.ask_player_name
    Player.new(user_name)
  rescue StandardError => e
    @interface.show_error_message(e)
    retry
  end

  ##############################################################

  def deal_2_cards_to_player
    @deck.deal(@player_hand, 2)
    @player_hand.flip_cards
  end

  def deal_2_cards_to_dealer
    @deck.deal(@dealer_hand, 2)
    @dealer_hand.first_card.flip_card if Config::DEALER_FLIP_CARDS_COUNT == 1
  end

  def give_two_cards_to_players
    if @deck.size < 6
      @interface.show_new_line
      @interface.show_header_game_over
      @interface.show_error_not_enough_cards
      winner_of_the_game
    else
      deal_2_cards_to_player
      deal_2_cards_to_dealer
    end
  end

  def winner_of_the_game
    @interface.show_new_line
    if @dealer.bank == @player.bank
      @interface.show_winner_of_the_game_draw
    elsif @player.bank > @dealer.bank
      @interface.show_winner_of_the_game(@player)
    elsif @player.bank < @dealer.bank
      @interface.show_winner_of_the_game(@dealer)
    end
    finish_game
  end

  def finish_game
    @interface.show_new_line
    abort 'Good bye! Come back soon!'
  end

  ##############################################################

  def make_round_bet(player, dealer)
    @interface.show_new_line
    if player.bank.zero?
      @interface.show_header_game_over
      @interface.show_message_bank_is_empty(player)
      winner_of_the_game
    elsif dealer.bank.zero?
      @interface.show_header_game_over
      @interface.show_message_bank_is_empty(dealer)
      winner_of_the_game
    end
    @bank.bet(player, dealer)
  end

  ##############################################################

  def playing?
    @playing
  end

  ##############################################################
  #
  # Skip Turn (Stand)
  #
  ##############################################################

  def stand
    if @player_hand.size == 3 && @dealer_hand.size == 3
      open_cards
    else
      @interface.show_new_line
      @interface.show_message_stands(@player)
    end

    if @dealer_hand.size < 3
      dealer_turn
    else
      @interface.show_message_stands(@dealer)
      player_choose_step
    end
  end

  def dealer_turn
    if @dealer_hand.total_points < Config::DEALER_MAX && @player_hand.size == 3
      @deck.deal(@dealer_hand, 1)
      @interface.show_message_take_card(@dealer)
      open_cards
    elsif @dealer_hand.total_points < Config::DEALER_MAX && @player_hand.size < 3
      @deck.deal(@dealer_hand, 1)
      @interface.show_message_take_card(@dealer)
      player_choose_step
    elsif @dealer_hand.total_points > Config::DEALER_MAX && @player_hand.size < 3
      @interface.show_message_stands(@dealer)
      player_choose_step
    elsif @dealer_hand.total_points > Config::DEALER_MAX && @player_hand.size == 3
      @interface.show_message_stands(@dealer)
      open_cards
    end
  end

  ##############################################################
  #
  # Add Card (Hit)
  #
  ##############################################################

  def hit
    @interface.show_new_line

    if @player_hand.size < 3
      @deck.deal(@player_hand, 1)
      @player_hand.last_card.flip_card
      @interface.show_new_line
      @interface.show_message_take_card(@player)
    else
      player_choose_step
    end

    if @dealer_hand.size < 3
      dealer_turn
    else
      @interface.show_message_stands(@dealer)
      player_choose_step
    end
  end

  ##############################################################
  #
  # Open Cards
  #
  ##############################################################

  def open_cards
    @dealer_hand.flip_cards_all_up
    set_result
  end

  ##############################################################
  #
  # Set Result
  #
  ##############################################################

  def set_result
    @interface.show_header_round_winner
    @interface.show_status(@player, @player_hand)
    @interface.show_status(@dealer, @dealer_hand)
    @interface.show_new_line
    @interface.show_info(@bank)

    check_result_core

    clear_hands(@player_hand, @dealer_hand)
    ask_next_round
  end

  def check_result_core
    if @player_hand.total_points == @dealer_hand.total_points
      result_draw
    elsif @dealer_hand.blackjack?
      result_blackjack(@dealer)
    elsif @player_hand.blackjack?
      result_blackjack(@player)
    elsif @player_hand.not_busted? && @dealer_hand.not_busted?
      check_player_and_dealer
    elsif @player_hand.not_busted? && @dealer_hand.busted?
      result_win(@player)
    else
      result_win(@dealer)
    end
  end

  def check_player_and_dealer
    if @player_hand.total_points > @dealer_hand.total_points
      result_win(@player)
    else
      result_win(@dealer)
    end
  end

  def clear_hands(player_hand, dealer_hand)
    player_hand.clear
    dealer_hand.clear
  end

  def result_blackjack(player)
    @bank.win(player)
    @interface.show_blackjack_winner(player)
  end

  def result_draw
    @bank.draw(@player, @dealer)
    @interface.show_result_draw
  end

  def result_win(player)
    @bank.win(player)
    @interface.show_result_winner(player)
  end

  def ask_next_round
    user_input = @interface.ask_yes_no_to_action('start another round?')
    if user_input == 2
      @interface.show_header_game_over
      winner_of_the_game
    end

    init
  end
end
