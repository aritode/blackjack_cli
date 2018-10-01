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

      @interface.show_display_menu

      user_choice = gets.to_i
      abort 'Good bye!' if user_choice.zero?

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
    deal_2_cards_to_player
    deal_2_cards_to_dealer
  end

  ##############################################################

  def make_round_bet(player, dealer)
    if player.bank.zero?
      @interface.show_message_bank_is_empty(player)
    elsif dealer.bank.zero?
      @interface.show_message_bank_is_empty(dealer)
    end
    @bank.bet(player, dealer)
  end

  ##############################################################

  def playing?
    @playing
  end

  def dealer_flip_cards_up
    case Config::DEALER_FLIP_CARDS_COUNT
    when 1
      @dealer_hand.last_card.flip_card unless @dealer_hand.last_card.face_up?
    when 2
      @dealer_hand.flip_cards
    else
      puts 'Error: !!!'
    end
  end

  ##############################################################
  #
  # Skip Turn (Stand)
  #
  ##############################################################

  def stand
    dealer_flip_cards_up if Config::DEALER_FLIP_CARDS_COUNT == 1 && @dealer_hand.size == 2
    dealer_turn
  end

  def dealer_turn
    if @dealer_hand.total_points < Config::DEALER_MAX && @player_hand.size == 3
      @deck.deal(@dealer_hand, 1)
      @interface.show_message_take_card(@dealer)
      set_result
    elsif @dealer_hand.total_points < Config::DEALER_MAX && @player_hand.size < 3
      @deck.deal(@dealer_hand, 1)
      @interface.show_message_take_card(@dealer)
      player_choose_step
    elsif @dealer_hand.total_points > Config::DEALER_MAX && @player_hand.size < 3
      @interface.show_message_stands(@dealer)
      player_choose_step
    elsif @dealer_hand.total_points > Config::DEALER_MAX && @player_hand.size == 3
      @interface.show_message_stands(@dealer)
      player_choose_step
    end
  end

  ##############################################################
  #
  # Add Card (Hit)
  #
  ##############################################################

  def hit
    @deck.deal(@player_hand, 1)
    @player_hand.last_card.flip_card
    @interface.show_message_take_card(@player)
    @interface.show_status(@player, @player_hand)
    dealer_turn
  end

  ##############################################################
  #
  # Open Cards
  #
  ##############################################################

  def open_cards
    dealer_flip_cards_up
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
    check_for_draw
    check_for_blackjack

    if @player_hand.not_busted? && @dealer_hand.not_busted?
      check_player_and_dealer
    elsif @player_hand.not_busted? && @dealer_hand.busted?
      result_win(@player)
    else
      result_win(@dealer)
    end
  end

  def check_for_blackjack
    result_blackjack(@dealer) if @dealer_hand.blackjack?
    result_blackjack(@player) if @player_hand.blackjack?
  end

  def check_for_draw
    result_draw if @player_hand.total_points == @dealer_hand.total_points
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
    abort 'Good Bye!' if user_input == 2

    init
  end
end
