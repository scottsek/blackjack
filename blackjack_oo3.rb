class Card
  attr_accessor :rank, :suit, :face_down

  def initialize(r, s, f_down = false)
    @rank = r
    @suit = s
    @face_down = f_down
  end

  def to_s
    if face_down
      "Card is face down"
    else
      card_display
    end
  end

  def card_display
    "#{rank_word} of #{suit_word}"
  end

  def suit_word
    case suit
    when 'H'
      'Hearts'
    when 'D'
      'Diamonds'
    when 'S'
      'Spades'
    when 'C'
      'Clubs'
    else
      suit
    end
  end

  def rank_word
    case rank
    when '2'..'9'
      rank
    when 'T'
      'Ten'
    when 'J'
      'Jack'
    when 'Q'
      'Queen'
    when 'K'
      'King'
    when 'A'
      'Ace'
    else
    end
  end

  def to_points
    case rank
    when '2','3','4','5','6','7','8','9'
      rank.to_i
    when 'T','J','Q','K'
      10
    when 'A'
      11
    else
    end
  end
end

class Shoe
  attr_accessor :shoe_cards
  
  SUITS = %w(S H D C)
  RANKS = %w(A 2 3 4 5 6 7 8 9 T J Q K)    

  def initialize(number_of_decks = 1)
    @shoe_cards = []
    number_of_decks.times do
      SUITS.each do |suit|
        RANKS.each do |rank|
          @shoe_cards << Card.new(rank, suit)
        end
      end
    end
    @shoe_cards.shuffle!
  end

  def deal_card(face_down = false)
    one_card = @shoe_cards.pop
    one_card.face_down = face_down
    one_card
  end

  def deal_face_down
    deal_card(true)
  end

  def to_s
    @shoe_cards.inspect
  end
end

module Hand
  
  def show_hand
    puts "#{name}'s Hand:"
    cards.each do |c|
      puts "=> #{c}"
    end
    puts "=> Points showing: #{points_total}"
  end

  def points_total
    total = 0
    ace_counter = 0
    cards.each do |c|
      if !c.face_down
        total += c.to_points
        if c.rank == 'A' then ace_counter += 1 end
        #saw the solution on the video, gave me the right 'framework' for the solution, but wanted to try this instead
        while total > 21 && ace_counter > 0
          total -= 10
          ace_counter -= 1
        end
      end
    end
    total
  end

  def has_busted?
    points_total > 21
  end

  def has_blackjack?
    points_total == 21
  end
end

class Player
  include Hand
  attr_accessor :name, :cards
  def initialize(n)
    @name = n
    @cards = []
  end
  def takes_turn(shoe)
    continue = true
    while continue
      puts 'H)it or S)tay'
      response = gets.chomp
      case response.upcase
      when 'H'
        cards << shoe.deal_card
        show_hand
      when 'S'
        continue = false
      else
        puts "I didn't understand your response."
      end
      if has_busted?
        puts "You busted!"
        continue = false
      end
      if has_blackjack?
        puts "You have blackjack"
        continue  = false
      end
    end
  end
end

class Dealer < Player
  def initialize
    super "Dealer"
  end
  def takes_turn(shoe)
    cards[0].face_down = false
    puts "Dealer turns card over... #{cards[0]}"
    show_hand
    continue = points_total < 17
    while continue
      cards << shoe.deal_card
      continue = points_total < 17
    end
  end
end

class Blackjack
  attr_accessor :shoe, :player, :dealer
  def initialize(decks,name)
    @shoe = Shoe.new(decks)
    @player = Player.new(name)
    @dealer = Dealer.new
  end

  def deal_hands
    player.cards << shoe.deal_card
    dealer.cards << shoe.deal_face_down
    player.cards << shoe.deal_card
    dealer.cards << shoe.deal_card
    player.show_hand
    dealer.show_hand
  end

  def compare_hands
    if !player.has_busted? and dealer.has_busted?
      puts 'You win. Dealer busted.'
    
    elsif player.has_blackjack? and !dealer.has_blackjack?
      puts 'You win with blackjack'
    
    elsif player.points_total > dealer.points_total
      puts 'You win on points.'
    else
      puts 'You lose.'
    end
  end

  def play_game
    deal_hands
    puts player.has_blackjack?
    if player.has_blackjack?
      puts "I assume you're staying!"
    else
      player.takes_turn(@shoe)
    end
    if player.has_busted?
      puts "Sorry you busted."
      exit
    else
      dealer.takes_turn(shoe)
    end
    player.show_hand
    dealer.show_hand
    compare_hands
  end
end

bj = Blackjack.new(1,'Scott')
bj.play_game




