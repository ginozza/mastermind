# Initialize MastermindGame object
class MastermindGame
  COLORS = %w[R G B Y O P].freeze
  CODE_LENGTH = 4

  def initialize
    @secret_code = []
    @guess_history = []
    @feedback_history = []
    @computer_guesses = []
    setup_game
  end

  def setup_game
    puts "Do you want to be the code creator or the guesser? (Enter 'creator' or 'guesser')"
    role = gets.chomp.downcase

    if role == "creator"
      player_creates_code
      computer_guesses_code
    elsif role == "guesser"
      computer_creates_code
      player_guesses_code
    else
      puts "Invalid choice. Please enter 'creator' or 'guesser'."
      setup_game
    end
  end

  def computer_creates_code
    @secret_code = Array.new(CODE_LENGTH) { COLORS.sample }
    puts "The computer has created a secret code. Start guessing!"
  end

  def player_creates_code
    puts "Enter your secret code (#{CODE_LENGTH} letters from #{COLORS.join(', ')}):"
    input = gets.chomp.upcase.chars
    if valid_code?(input)
      @secret_code = input
    else
      puts "Invalid code. Please enter exactly #{CODE_LENGTH} letters from #{COLORS.join(', ')}."
      player_creates_code
    end
  end

  def player_guesses_code
    until @guess_history.last == @secret_code
      puts "Enter your guess (#{CODE_LENGTH} letters from #{COLORS.join(', ')}):"
      guess = gets.chomp.upcase.chars
      if valid_code?(guess)
        feedback = get_feedback(guess)
        @guess_history << guess
        @feedback_history << feedback
        puts "Feedback: #{feedback}"
      else
        puts "Invalid guess. Please enter exactly #{CODE_LENGTH} letters from #{COLORS.join(', ')}."
      end
    end
    puts "Congratulations! You've guessed the secret code!"
  end

  def computer_guesses_code
    possible_guesses = COLORS.repeated_permutation(CODE_LENGTH).to_a
    until possible_guesses.empty?
      @computer_guesses = possible_guesses.sample
      possible_guesses.delete(@computer_guesses)
      feedback = get_feedback(@computer_guesses)
      puts "Computer's guess: #{@computer_guesses.join}, Feedback: #{feedback}"

      break if feedback == "4A0B"

      refine_computer_guess(feedback)
    end
    puts "The computer has guessed your secret code!"
  end

  def refine_computer_guess(feedback)
    a_count = feedback.split("A").first.to_i
    return unless a_count < CODE_LENGTH

    unused_colors = COLORS - @computer_guesses
    a_count.times { |i| @computer_guesses[i] = COLORS.sample }
    @computer_guesses.fill { |i| unused_colors[i % unused_colors.size] }
  end

  def get_feedback(guess)
    a = guess.zip(@secret_code).count { |g, s| g == s }
    b = guess.uniq.count { |color| @secret_code.include?(color) } - a
    "#{a}A#{b}B"
  end

  def valid_code?(code)
    code.length == CODE_LENGTH && code.all? { |color| COLORS.include?(color) }
  end
end

# Create a new MastermindGame object
MastermindGame.new
