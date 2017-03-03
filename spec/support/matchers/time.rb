RSpec::Matchers.define :a_time_close_to do |expected|
  match do |actual|
    (expected - 1.second..expected + 1.second).cover?(actual.to_i)
  end

  description do
    "a time close to #{expected}"
  end
end

def be_a_time_close_to(time)
  a_time_close_to time
end
