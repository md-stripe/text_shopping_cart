require 'stripe'
require_relative 'secrets.txt'
Stripe.api_key = $SECRET_KEY

# METHODS
def get_card_info
  card = {}
  puts "Enter your credit card number:"
  card[:number] = gets.chomp
  puts "Enter your expiration month:"
  card[:exp_month] = gets.chomp
  puts "Enter your expiration year:"
  card[:exp_year] = gets.chomp
  puts "Enter your CVC:"
  card[:cvc] = gets.chomp
  card
end

def create_customer
  customer = {}
  puts "Enter your name:"
  customer[:description] = gets.chomp
  puts "Enter your email address:"
  customer[:email] = gets.chomp
  puts
  customer
end

def stringify_to_dollars(cents)
  dollars = '%.2f' % (cents / 100.0)
  "$#{dollars}"
end

def run_charge(user_card, amount)
  puts "-" * 10    # this just prints "----------"
  puts
  puts "The charge method would run here,"
  puts "but there's not much logic here yet."
  puts "You'll add that later!"
  puts "It would use this card info:"
  puts "Card number: #{user_card[:number]}"
  puts "Card exp: #{user_card[:exp_month]}/#{user_card[:exp_year]}"
  puts "Card cvc: #{user_card[:cvc]}"
  puts
  puts "And it would use this amount:"
  puts
  p amount
  puts "-" * 10
  # Create a Stripe token
  token = Stripe::Token.create(
    :card => user_card
  )

  # Use the token to create a Stripe charge
  charge = Stripe::Charge.create(
    :amount => amount,
    :currency => "usd",
    :description => "Example charge",
    :source => token,
  )

  puts "Your card has been charged #{stringify_to_dollars(amount)}."
end

def get_user_choice(products)
  puts
  puts "AVAILABLE PRODUCTS"
  products.each_with_index do |product, index|
    puts "#{index + 1}. #{product[:description]} - #{stringify_to_dollars(product[:price])}"
  end
  puts "Would you like to buy a product? (y/N)"
  like_to_buy = gets.chomp
  if like_to_buy.upcase == "Y"
    puts "Enter the number of the product you want to buy:"
    index = gets.to_i - 1
  else
    puts "You didn't pick a product."
    return
  end
  products[index]
end

# List of products. This is an array of hashes.
products = [
  {description: "red jacket", price: 4500},
  {description: "blue shoes", price: 5500},
  {description: "fly socks", price: 1500},
  {description: "sweet hat", price: 5600}
]

# DRIVER CODE

=begin
# 1. Lists the available products
# 2. Ask the user for their choice
userchoice = get_user_choice(products)
# 3. Displays the user's selection and total
puts "You want to buy: #{userchoice[:description]}"
puts "This item costs: #{stringify_to_dollars(userchoice[:price])}"

# 4. Asks the user for their card information
user_card = get_card_info

# 5. Charge the user card
run_charge(user_card,userchoice[:price])

# 6. Bid farwell
puts "Thank you for purchasing #{userchoice[:description]}"
=end

puts
puts "========================================"
puts "Welcome to the Text Store of the Future."
puts "========================================"
puts
in_store = true
cart = Array.new
current_customer = Array.new

while in_store do
  puts
  puts "--------------------------"
  puts "What would you like to do?"
  puts
  puts "1. List available products"
  puts "2. Become a member"
  puts "3. Exit the store"
  if cart.count > 0
    puts "4. View your shopping cart (#{cart.count} item(s)"
  end
  puts "--------------------------"
  puts
  to_do = gets.chomp.to_i

  if to_do == 1
    # Display a list of products
    selected_product = get_user_choice(products)
    if selected_product != nil
      cart << selected_product
    end
  elsif to_do == 2
    # create a customer
    if not current_customer.any? # if array not empty
      current_customer = create_customer
      puts "Welcome #{current_customer[:description]} you are now a member!"
    else
      puts "#{current_customer[:description]}, you are already a member."
    end
  elsif to_do == 3
    # Exit the store
    puts "You are exiting the store!"
    in_store = false
  elsif to_do == 4
    # Review the list of items in your shopping cart
  else
    # Remind them they must choose an available option
    puts "You need to pick from the available options."
  end

end
puts
puts "Thank you for shopping at Text Store!"
puts
puts "Here is your receipt!"
puts "---------------------"
puts
