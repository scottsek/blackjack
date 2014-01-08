# Blackjack Game

# Rules & Requirements: 
# Blackjack is a card game where you calculate the sum of the values of your cards and try to hit 21, aka "blackjack".
#Both the player and dealer are dealt two cards to start the game.
#All face cards are worth whatever numerical value they show. Suit cards are worth 10.
#Aces can be worth either 11 or 1. Example: if you have a Jack and an Ace, then you have hit "blackjack", as it adds up to 21.

# After being dealt the initial 2 cards, the player goes first and can choose to either "hit" or "stay".
#Hitting means deal another card. If the player's cards sum up to be greater than 21, the player has "busted" and lost.
#If the sum is 21, then the player wins. If the sum is less than 21, then the player can choose to "hit" or "stay" again. If the player "hits", then repeat above, but if the player stays, then the player's total value is saved, and the turn moves to the dealer.

# By rule, the dealer must hit until she has at least 17. If the dealer busts, then the player wins.
#If the dealer, hits 21, then the dealer wins. 
#If, however, the dealer stays, then we compare the sums of the two hands between the player and dealer; higher value wins.

# Hints:
# 1. Think of the data structure required to keep track of cards in a deck. 
# 2. You'll need to look up and use a "while" loop, since there could be an indeterminate number of "hits" by both the player and dealer. "while" loops are used when we don't have a finite number of iterations.
# 3. Code something. Get started, even if it's just capturing the player's name. Give it an honest attempt before looking at solutions.
# 4. Use methods to extract the piece of functionality that calculates the total, since we need it throughout the program.

# Bonus:
# 1. Save the player's name, and use it throughout the app.
# 2. Ask the player if he wants to play again, rather than just exiting.
# 3. Save not just the card value, but also the suit. 
# 4. Use multiple decks to prevent against card counting players.

SUITS = %w(S H D C)
RANKS = %w(A 2 3 4 5 6 7 8 9 T J Q K)
DECKS = 6
def get_cards
  ordered_cards = []
  DECKS.times do 
    SUITS.each do |s| 
      RANKS.each do |r|
        ordered_cards << [r,s]
      end
    end
  end
  ordered_cards.shuffle
#saw product on the video, will use that in the future
end

def evaluate_hand hand
  total = 0
  ace_counter = 0
  hand.each do |c|
    case c[0]
    when '2','3','4','5','6','7','8','9'
      points = c[0].to_i
    when 'T','J','Q','K'
      points = 10
    when 'A'
      points = 11
      ace_counter += 1
    else
    end
    total += points
    #saw the solution on the video, gave me the right 'framework' for the solution, but wanted to try this instead
    while total > 21 && ace_counter > 0
      total -= 10
      ace_counter -= 1
    end
  end
  total
end

def show_points hand
  if ace_in_hand? then
    show = "#{evaluate_hand(hand)-10} or #{evaluate_hand(hand)}"
  else
    show = "#{evaluate_hand(hand)}"
  end    
end

def is_blackjack?(hand)
  evaluate_hand(hand) == 21
end

def is_busted?(hand)
  evaluate_hand(hand) > 21
end

def show_cards(hand)
  show=''
  hand.each do |c|
    show = show + "#{c[0]}#{c[1]} "
  end
  show
end

def deal_hand(deck)
  [deck.pop,deck.pop]
end

def add_card(hand, deck)
  hand << deck.pop
end

def dealer_must_play?(hand)
  evaluate_hand(hand) < 17
end
def user_continues?(response)
  if response.upcase = 'Y'
    true
  else
    false
  end
end
game_over = false
puts 'Welcome to Blackjack, what is your name?'
user_name = gets.chomp

deck = get_cards
keep_playing = true
while keep_playing
  users_hand = deal_hand(deck)
  dealers_hand = deal_hand(deck)
  dealers_points = evaluate_hand(dealers_hand)
  puts 'Your hand:'
  puts show_cards users_hand
  hand_just_dealt = true
  puts 'My hand:'
  puts show_cards dealers_hand
  if is_blackjack?(users_hand)
    puts "#{user_name}, you win with blackjack"
    game_over = true
  end
  user_continues = !is_blackjack?(users_hand)
  while user_continues do
    puts "#{user_name}, do you want to H)it or S)tay"
    users_answer = gets.chomp
    hand_just_dealt = false
    case users_answer.upcase
    when 'H'
      add_card users_hand, deck
      puts show_cards users_hand
      users_points = evaluate_hand(users_hand)
      puts "#{user_name}, your total is #{users_points}."
      if is_busted?(users_hand) 
        puts "You busted"
        user_continues = false
        game_over = true
      end
      if is_blackjack?(users_hand) 
        "You have blackjack"
        user_continues = false
      end
    when 'S'
      user_continues = false
   end
  end
  if !game_over
    puts "my total is #{dealers_points}."
    while dealer_must_play?(dealers_hand) && !is_busted?(dealers_hand) && !is_blackjack?(dealers_hand) do
      add_card dealers_hand, deck
      puts show_cards dealers_hand
      dealers_points = evaluate_hand(dealers_hand)
      puts "my total is #{dealers_points}."
    end
    if is_busted?(dealers_hand) && !is_busted?(users_hand)
      puts "#{user_name}, you win! I busted."
    else    
      if dealers_points >= users_points
        puts "I win, better luck next time, #{user_name}"
      else
        puts "#{user_name}, you win."
      end
    end
  end
  puts "Continue playing (y/n)?"
  yes_no = gets.chomp
  keep_playing = user_continues?(yes_no)
end