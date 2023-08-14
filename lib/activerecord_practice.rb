require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  def self.with_dot_org_email
    where("email LIKE '%.org%'")
  end

  def self.with_invalid_email
    where("email NOT LIKE '%@%' AND email IS NOT NULL AND email != ''")
  end

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    where(first: "Candice")
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    where("email LIKE '%@%'")
  end

  def self.with_blank_email
    where(email: [nil, ''])
  end

  def self.born_before_1980
    where("birthdate < ?", Date.new(1980, 1, 1))
  end

  def self.with_valid_email_and_born_before_1980
    with_valid_email.born_before_1980
  end
  
  def self.last_names_starting_with_b
    where("last LIKE 'B%'").order(:birthdate)
  end

  def self.twenty_youngest
    print order(:birthdate).limit(20)
  end

  def self.update_gussie_murray_birthdate
    gussie = find_by(first: 'Gussie', last: 'Murray')
    gussie.update(birthdate: Date.new(2004, 2, 8)) if gussie
  end

  def self.change_all_invalid_emails_to_blank
    where("email NOT LIKE '%@%' AND email IS NOT NULL AND email != ''").update_all(email: '')
  end

  def self.delete_meggie_herman
    where(first: 'Meggie', last: 'Herman').destroy_all
  end

  def self.delete_everyone_born_before_1978
    where("birthdate <= ?", Date.new(1977, 12, 31)).destroy_all
  end

end
