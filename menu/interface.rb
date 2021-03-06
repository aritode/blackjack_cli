# frozen_string_literal: true

class Interface
  def show_header_main_menu
    show_new_line
    puts '================================'
    puts '======== BLACKJACK GAME ========'
    puts '================================'
  end

  def show_header_game_over
    show_new_line
    puts '================================'
    puts '========== GAME OVER ==========='
    puts '================================'
    show_new_line
  end

  def show_header_round_winner
    show_new_line
    puts '================================'
    puts '======== ROUND WINNER =========='
    puts '================================'
    show_new_line
  end

  MENU_STEPS = ['Skip', 'Add Card', 'Open Cards', 'QUIT'].freeze

  def ask_player_name
    ask_enter('your name')
  end

  def ask_user_choose_next_step
    ask_choose('your', 'step', MENU_STEPS)
  end

  def show_full_status(player, dealer, bank)
    show_status(player, player.hand)
    show_status(dealer, dealer.hand)
    show_new_line
    show_info(bank)
  end

  def show_status(player, player_hand)
    show_header("#{player.name} ($#{player.bank})")
    puts player_hand
  end

  def show_message_take_card(player)
    show_info("#{player.name} take card")
  end

  def show_message_stands(player)
    show_info("#{player.name} stands (skip turn)")
  end

  def show_blackjack_winner(player)
    show_result("#{player.name} Wins! With 21 Blackjack!")
    show_info_bank(player)
  end

  def show_result_draw
    show_result('Draw! Everyone gets his bet back.')
  end

  def show_everyone_is_busted
    show_result('Everyone is Busted! Everyone gets his bet back.')
  end

  def show_result_winner(player)
    show_result("#{player.name} Wins!")
    show_info_bank(player)
  end

  def show_message_bank_is_empty(player)
    puts "#{player.name} Bank is Empty!"
    show_info_bank(player)
  end

  def show_winner_of_the_game(player)
    puts "Winner of the Game: #{player.name}"
    show_info_bank(player)
  end

  def show_winner_of_the_game_draw
    puts 'DRAW! There is no Winner of the Game!'
  end

  def show_info_bank(player)
    show_info("#{player.name} Bank: $#{player.bank}")
  end

  def show_error_not_enough_cards
    show_error_without_retry('Not enough cards in deck for next round!')
  end

  #
  # Show Helpers
  #

  def show_header(title)
    puts
    puts title
    puts '=' * title.length
  end

  def show_info(message)
    puts "[INFO] #{message}"
  end

  def show_result(message)
    puts "\n[RESULT] #{message}"
  end

  def show_new_line
    puts "\n"
  end

  def show_error_message(error)
    puts "\n[ERROR] #{error}"
    puts 'Please, try again'
  end

  def show_error_without_retry(error)
    puts "\n[ERROR] #{error}"
  end

  #
  # Ask/Get/Input Helpers
  #

  def ask_yes_no_to_action(action_name)
    title = "[ASK] Do you want to #{action_name}?"
    custom_list = ["Yes, let's #{action_name}",
                   'No, let\'s go Back']
    ordered_list_user_input(title, custom_list)
  end

  def ask_choose(item_name, additional_info, item_obj)
    title = "[ASK] Please choose #{item_name} #{additional_info}:"
    ordered_list_user_input(title, item_obj)
  end

  def ask_enter(item_name)
    title = "[ASK] Please enter #{item_name}:"
    characters_user_input(title)
  end

  def characters_user_input(title)
    show_header(title)
    print '=> '
    gets.chomp.strip
  end

  def ordered_list_user_input(title, items_array)
    show_header(title)
    items_array.each.with_index(1) do |item, i|
      puts "#{i}) #{item}"
    end
    print '=> '
    check_list_user_input(items_array)
  end

  def check_list_user_input(items_array)
    user_input = gets.to_i
    max_value = items_array.size
    if (1..max_value).cover?(user_input)
      user_input
    else
      puts "\nPlease enter number from 1 to #{max_value}"
      print '=> '
      check_list_user_input(items_array)
    end
  end
end
