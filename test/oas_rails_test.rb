require "test_helper"

class OasRailsTest < Minitest::Test
  def test_it_has_version_number
    assert OasRails::VERSION
  end

  def test_rails_app
    load_dummy(:rails)

    assert defined?(Rails), 'Rails is not defined'
  end
end
