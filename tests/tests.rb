# frozen_string_literal: true


require 'test/unit'
require_relative '../car_rental'

class CarTest < Test::Unit::TestCase
  def test_initialize
    car_instance = Car.new('car1', Car::SALOON)
    assert_equal 'car1', car_instance.title
    assert_equal 0, car_instance.style
  end
end

class RentalTest < Test::Unit::TestCase
  def test_initialize
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 5)

    assert_equal car_instance, rental_instance.car
    assert_equal 5, rental_instance.days_rented
  end

  def test_initialize_raise_error
    car_instance = Car.new('car1', Car::SALOON)

    assert_raise do
      Rental.new(car_instance, 0)
    end
  end
end

class DriverTest < Test::Unit::TestCase
  def test_initialize
    driver_instance = Driver.new('John')

    assert_equal 'John', driver_instance.name
  end

  def test_statement
    driver_instance = Driver.new('John')
    expected = "Car rental record for John\nAmount owed is €0\nEarned bonus points: 0"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_one_car_one_day
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,20\nAmount owed is €20\nEarned bonus points: 1"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_one_car_suv
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,30\nAmount owed is €30\nEarned bonus points: 1"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_suv_one_month
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 30)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,900\nAmount owed is €900\nEarned bonus points: 2"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_one_hatchback
    car_instance = Car.new('car1', Car::HATCHBACK)
    rental_instance = Rental.new(car_instance, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,15\nAmount owed is €15\nEarned bonus points: 1"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_hatchback_month
    car_instance = Car.new('car1', Car::HATCHBACK)
    rental_instance = Rental.new(car_instance, 30)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,420\nAmount owed is €420\nEarned bonus points: 1"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_saloon_month
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 30)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    expected = "Car rental record for John\ncar1,440\nAmount owed is €440\nEarned bonus points: 1"
    assert_equal expected, driver_instance.statement
  end

  def test_statement_multiple_cars
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    expected = "Car rental record for John\ncar1,20\ncar2,20\nAmount owed is €40\nEarned bonus points: 2"
    assert_equal expected, driver_instance.statement
  end
end
