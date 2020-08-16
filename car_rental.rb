# frozen_string_literal: true

require 'json'

class Car
  SALOON = 0
  SUV = 1
  HATCHBACK = 2

  attr_reader :title
  attr_accessor :style

  def initialize(title, style)
    @title = title
    @style = style
  end

  def base_rate
    style == Car::SUV ? 30 : 15
  end

  def initial_rate
    rate = 0
    if [Car::HATCHBACK, Car::SALOON].include? style
      rate = style == Car::HATCHBACK ? 15 : 20
    end
    rate
  end

  def base_days_discount
    days = 0
    if [Car::HATCHBACK, Car::SALOON].include? style
      days = style == Car::HATCHBACK ? 3 : 2
    end
    days
  end

end

class Rental
  attr_reader :car, :days_rented

  def initialize(car, days_rented)
    @car = car
    @days_rented = days_rented

    raise 'Error: days_rented invalid' if @days_rented <= 0
  end

  def amount
    this_amount = car.initial_rate
    this_amount += (days_rented - car.base_days_discount) * car.base_rate if days_rented > car.base_days_discount
    this_amount
  end

  def bonus_points
    bonus_points = amount.negative? ? -10 : 1
    bonus_points += 1 if car.style == Car::SUV && days_rented > 1
    bonus_points
  end

  def to_s
    car.title.to_s + ',' + amount.to_s + "\n"
  end

  def car_amount
    [car.title.to_s, amount]
  end
end

class Driver
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  def total_bonus
    bonus_points = 0
    @rentals.each do |r|
      bonus_points += r.bonus_points
    end
    bonus_points
  end

  def total_owed
    total = 0
    @rentals.each do |r|
      total += r.amount
    end
    total
  end

  def statement
    total = 0
    bonus_points = 0
    result = "Car rental record for #{@name}\n"
    @rentals.each do |r|
      this_amount = r.amount
      total += this_amount
      bonus_points += r.bonus_points

      result += r.to_s
    end

    result += 'Amount owed is €' + total.to_s + "\n"
    result += 'Earned bonus points: ' + bonus_points.to_s
  end

  def statements
    result = []
    @rentals.each do |r|
      result << r.car_amount
    end
    result
  end

  def json_statement
    statement_hash = {
        :name => name,
        :bonus_points => total_bonus,
        :amount_owed => total_owed,
        :statements => statements
    }
    JSON.generate(statement_hash)
  end

  def json_statement2
    # second option cycling only once on the rentals list
    bonus_total = 0
    owed_total = 0
    statements_array = []
    @rentals.each do |r|
      owed_total += r.amount
      bonus_total += r.bonus_points
      statements_array << r.car_amount
    end
    statement_hash = {
        :name => name,
        :bonus_points => bonus_total,
        :amount_owed => owed_total,
        :statements => statements_array
    }
    JSON.generate(statement_hash)
  end
end
