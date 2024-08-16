class SecretNumberGame
  def initialize
    @attempts = 0
    @array_sorted_numbers = []
    puts "Enter a maximum number for the secret number range:"
    @numero_maximo = gets.chomp.to_i
    @max_attempts = 12
    start_game
  end

  def start_game
    @secret_number = initial_conditions
    loop do
      correct_guess = check_attempt
      @attempts += 1

      next unless correct_guess || @attempts >= @max_attempts

      if @attempts >= @max_attempts && !correct_guess
        assign_text("You've reached the maximum of #{@max_attempts} attempts!")
      end

      puts "Do you want to keep playing? (y/n)"
      response = gets.chomp.downcase
      break unless response == "y"

      reset_game
    end
  end

  private

  def assign_text(text)
    puts text
  end

  def check_attempt
    puts "Enter your guess:"
    user_number = gets.chomp.to_i

    if user_number == @secret_number
      assign_text("You guessed the number in #{@attempts} #{@attempts == 1 ? 'try' : 'tries'}!")
      true
    else
      if user_number > @secret_number
        assign_text("The secret number is lower")
      else
        assign_text("The secret number is higher")
      end
      false
    end
  end

  def generate_secret_number
    generated_number = rand(1..@numero_maximo)

    if @array_sorted_numbers.length == @numero_maximo
      assign_text("All possible numbers have been drawn")
      nil
    elsif @array_sorted_numbers.include?(generated_number)
      generate_secret_number
    else
      @array_sorted_numbers << generated_number
      generated_number
    end
  end

  def initial_conditions
    assign_text("Secret Number Game!")
    assign_text("Guess a number between 1 and #{@numero_maximo}")
    generate_secret_number
  end

  def reset_game
    @array_sorted_numbers = []
    @attempts = 0
    @secret_number = initial_conditions
  end
end

# Start the game
SecretNumberGame.new
