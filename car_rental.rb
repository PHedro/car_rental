# frozen_string_literal: true

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
end

class Rental
  attr_reader :car, :days_rented

  def initialize(car, days_rented)
    @car = car
    @days_rented = days_rented

    raise 'Error: days_rented invalid' if @days_rented <= 0
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

  def statement
    total = 0
    bonus_points = 0
    result = "Car rental record for #{@name}\n"
    @rentals.each do |r|
      this_amount = 0
      case r.car.style
      when Car::SUV
        this_amount += r.days_rented * 30
      when Car::HATCHBACK
        this_amount += 15
        this_amount += (r.days_rented - 3) * 15 if r.days_rented > 3
      when Car::SALOON
        this_amount += 20
        this_amount += (r.days_rented - 2) * 15 if r.days_rented > 2
      end

      bonus_points -= 10 if this_amount.negative?

      bonus_points += 1
      bonus_points += 1 if r.car.style == Car::SUV && r.days_rented > 1

      result += r.car.title.to_s + ',' + this_amount.to_s + "\n"
      total += this_amount
    end

    result += 'Amount owed is €' + total.to_s + "\n"
    result += 'Earned bonus points: ' + bonus_points.to_s
    result
  end
end
