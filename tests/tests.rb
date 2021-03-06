# frozen_string_literal: true


require 'test/unit'
require_relative '../car_rental'

class CarTest < Test::Unit::TestCase
  def test_initialize
    car_instance = Car.new('car1', Car::SALOON)
    assert_equal 'car1', car_instance.title
    assert_equal 0, car_instance.style
  end

  def test_base_rate_suv
    car_instance = Car.new('car1', Car::SUV)
    assert_equal 30, car_instance.base_rate
  end

  def test_base_rate_saloon
    car_instance = Car.new('car1', Car::SALOON)
    assert_equal 15, car_instance.base_rate
  end

  def test_base_rate_hatchback
    car_instance = Car.new('car1', Car::HATCHBACK)
    assert_equal 15, car_instance.base_rate
  end

  def test_initial_rate_suv
    car_instance = Car.new('car1', Car::SUV)
    assert_equal 0, car_instance.initial_rate
  end

  def test_initial_rate_saloon
    car_instance = Car.new('car1', Car::SALOON)
    assert_equal 20, car_instance.initial_rate
  end

  def test_initial_rate_hatchback
    car_instance = Car.new('car1', Car::HATCHBACK)
    assert_equal 15, car_instance.initial_rate
  end

  def test_base_days_suv
    car_instance = Car.new('car1', Car::SUV)
    assert_equal 0, car_instance.base_days_discount
  end

  def test_base_days_saloon
    car_instance = Car.new('car1', Car::SALOON)
    assert_equal 2, car_instance.base_days_discount
  end

  def test_base_days_hatchback
    car_instance = Car.new('car1', Car::HATCHBACK)
    assert_equal 3, car_instance.base_days_discount
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

  def test_rental_amount
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal 30, rental_instance.amount
  end

  def test_rental_amount_suv_month
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 30)
    assert_equal 900, rental_instance.amount
  end

  def test_rental_amount_hatch_month
    car_instance = Car.new('car1', Car::HATCHBACK)
    rental_instance = Rental.new(car_instance, 30)
    assert_equal 420, rental_instance.amount
  end

  def test_rental_amount_hatchback
    car_instance = Car.new('car1', Car::HATCHBACK)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal 15, rental_instance.amount
  end

  def test_rental_saloon_month
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 30)
    assert_equal 440, rental_instance.amount
  end

  def test_rental_amount_saloon
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal 20, rental_instance.amount
  end

  def test_bonus_points
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal 1, rental_instance.bonus_points
  end

  def test_bonus_points_2_days
    car_instance = Car.new('car1', Car::SUV)
    rental_instance = Rental.new(car_instance, 2)
    assert_equal 2, rental_instance.bonus_points
  end

  def test_bonus_points_saloon
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal 1, rental_instance.bonus_points
  end

  def test_bonus_saloon_2_days
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 2)
    assert_equal 1, rental_instance.bonus_points
  end

  def test_to_s
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal "car1,20\n", rental_instance.to_s
  end

  def test_car_amount
    car_instance = Car.new('car1', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    assert_equal ['car1', 20], rental_instance.car_amount
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

  def test_statemens
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    expected = [['car1', 20], ['car2', 20]]
    assert_equal expected, driver_instance.statements
  end

  def test_total_bonus
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    assert_equal 2, driver_instance.total_bonus
  end

  def test_total_owed
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    assert_equal 40, driver_instance.total_owed
  end

  def test_json_statement
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    expected = "{\"name\":\"John\",\"bonus_points\":2,\"amount_owed\":40,\"statements\":[[\"car1\",20],[\"car2\",20]]}"
    assert_equal expected, driver_instance.json_statement
  end

  def test_json_statement2
    car_instance = Car.new('car1', Car::SALOON)
    car_instance2 = Car.new('car2', Car::SALOON)
    rental_instance = Rental.new(car_instance, 1)
    rental_instance2 = Rental.new(car_instance2, 1)
    driver_instance = Driver.new('John')
    driver_instance.add_rental rental_instance
    driver_instance.add_rental rental_instance2
    expected = "{\"name\":\"John\",\"bonus_points\":2,\"amount_owed\":40,\"statements\":[[\"car1\",20],[\"car2\",20]]}"
    assert_equal expected, driver_instance.json_statement2
  end
end
