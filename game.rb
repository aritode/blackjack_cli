# frozen_string_literal: true

class Game
  def initialize(interface)
    @interface = interface
    @player = create_player
    @dealer = Dealer.new
    @deck = Deck.new
    @bank = Bank.new
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
      @interface.show_full_status(@player, @dealer, @bank)

      open_cards if @player.hand_size == Config::CARDS_MAX && @dealer.hand_size == Config::CARDS_MAX

      user_choice = @interface.ask_user_choose_next_step
      finish_game if user_choice == 4

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

  def deal_card(player)
    card = @deck.deal
    player.take_card(card)
  end

  def deal_2_cards_to_player
    2.times { deal_card(@player) }
    @player.flip_cards
  end

  def deal_2_cards_to_dealer
    2.times { deal_card(@dealer) }
    @dealer.first_card.flip_card if Config::DEALER_FLIP_CARDS_COUNT == 1
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
    make_round_bet_show_bank_empty(player) if player.bank.zero?
    make_round_bet_show_bank_empty(dealer) if dealer.bank.zero?
    @bank.bet(player, dealer)
  end

  def make_round_bet_show_bank_empty(player)
    @interface.show_header_game_over
    @interface.show_message_bank_is_empty(player)
    winner_of_the_game
  end

  ##############################################################
  #
  # Skip Turn (Stand)
  #
  ##############################################################

  def stand
    stand_player_check_hand_size
    stand_dealer_check_hand_size
  end

  def stand_player_check_hand_size
    if @player.hand_size == Config::CARDS_MAX && @dealer.hand_size == Config::CARDS_MAX
      open_cards
    else
      @interface.show_new_line
      @interface.show_message_stands(@player)
    end
  end

  def stand_dealer_check_hand_size
    if @dealer.hand_size < Config::CARDS_MAX
      dealer_turn
    else
      @interface.show_message_stands(@dealer)
      player_choose_step
    end
  end

  def dealer_turn
    if @dealer.score < Config::DEALER_MAX
      dealer_turn_check_if_deal_on
    else
      dealer_turn_check_if_deal_off
    end
  end

  def dealer_turn_check_if_deal_on
    if @player.hand_size == Config::CARDS_MAX
      deal_card(@dealer)
      @interface.show_message_take_card(@dealer)
      open_cards
    elsif @player.hand_size < Config::CARDS_MAX
      deal_card(@dealer)
      @interface.show_message_take_card(@dealer)
      player_choose_step
    end
  end

  def dealer_turn_check_if_deal_off
    if @player.hand_size < Config::CARDS_MAX
      @interface.show_message_stands(@dealer)
      player_choose_step
    elsif @player.hand_size == Config::CARDS_MAX
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

    hit_check_player_hand_size
    hit_check_dealer_hand_size
  end

  def hit_check_player_hand_size
    if @player.hand_size < Config::CARDS_MAX
      deal_card(@player)
      @player.last_card.flip_card

      @interface.show_new_line
      @interface.show_message_take_card(@player)
    else
      player_choose_step
    end
  end

  def hit_check_dealer_hand_size
    if @dealer.hand_size < Config::CARDS_MAX
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
    @dealer.flip_cards
    set_result
  end

  ##############################################################
  #
  # Set Result
  #
  ##############################################################

  def set_result
    @interface.show_header_round_winner
    @interface.show_full_status(@player, @dealer, @bank)

    check_result

    @player.clear_hand
    @dealer.clear_hand
    ask_next_round
  end

  def check_result
    if @player.busted? && @dealer.busted?
      result_everyone_is_busted
    else
      check_result_draw_blackjack
    end
  end

  def check_result_draw_blackjack
    if @player.score == @dealer.score
      result_draw
    elsif @dealer.blackjack?
      result_blackjack(@dealer)
    elsif @player.blackjack?
      result_blackjack(@player)
    else
      check_result_core
    end
  end

  def check_result_core
    if @player.not_busted? && @dealer.not_busted?
      check_player_and_dealer
    elsif @player.not_busted? && @dealer.busted?
      result_win(@player)
    else
      result_win(@dealer)
    end
  end

  def check_player_and_dealer
    if @player.score > @dealer.score
      result_win(@player)
    else
      result_win(@dealer)
    end
  end

  def result_blackjack(player)
    @bank.win(player)
    @interface.show_blackjack_winner(player)
  end

  def result_draw
    @bank.draw(@player, @dealer)
    @interface.show_result_draw
  end

  def result_everyone_is_busted
    @bank.draw(@player, @dealer)
    @interface.show_everyone_is_busted
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
