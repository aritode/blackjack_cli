# frozen_string_literal: true

class Interface
  def show_header_main_menu
    puts '================================'
    puts '======== BLACKJACK GAME ========'
    puts '================================'
  end

  def show_display_menu
    puts
    puts <<~DISPLAY_MENU
      1. Skip
      2. Add Card
      3. Open Cards
      0. QUIT
    DISPLAY_MENU
    print '=> '
  end

  def ask_player_name
    ask_enter('your name')
  end

  def show_status(player, player_hand)
    show_header("#{player.name} ($#{player.bank})")
    puts player_hand.show_hand.to_s
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
    show_result('Draw!')
  end

  def show_result_winner(player)
    show_result("#{player.name} Wins!")
    show_info_bank(player)
  end

  def show_message_bank_is_empty(player)
    puts 'Bank is Empty!'
    show_info_bank(player)
  end

  def show_header_round_winner
    show_header('ROUND WINNER:')
    show_result('')
  end

  def show_info_bank(player)
    puts "[INFO] Update #{player.name} bank: $#{player.bank}"
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

  def ask_yes_no_to_create(name)
    title = "Do you want to create #{name}?"
    custom_list = ["Yes, let's create #{name}",
                   'No, let\'s go Back']
    ordered_list_user_input(title, custom_list)
  end

  def ask_yes_no_to_action(action_name)
    title = "[NEW] Do you want to #{action_name}?"
    custom_list = ["Yes, let's #{action_name}",
                   'No, let\'s go Back']
    ordered_list_user_input(title, custom_list)
  end

  def ask_choose(item_name, additional_info, item_obj)
    title = "[NEW] Please choose #{item_name} #{additional_info}:"
    ordered_list_user_input(title, item_obj)
  end

  def ask_enter(item_name)
    title = "[NEW] Please enter #{item_name}:"
    characters_user_input(title)
  end

  def show_error_message(error)
    puts "\n[ERROR] #{error}"
    puts 'Please, try again'
  end

  def show_header(title)
    puts
    puts title
    puts '=' * title.length
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
