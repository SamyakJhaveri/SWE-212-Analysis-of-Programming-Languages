# https://www.giulianomega.com/post/2019-11-11-generators/
# Continuations in Ruby
# https://ruby-doc.org/core-2.5.0/Fiber.html
# https://stackoverflow.com/questions/2504494/are-there-something-like-python-generators-in-ruby
'''
require "continuation"

$x = nil
results = []

def fun .
    i = 0
    callcc{
        |x|
        $x = x
    }
    i += 1
    i 
end

results << r = fun
$x.call unless r >= 10
puts "Result is:" + results.join(", ")
'''
'''
fiber = Fiber.new do |first|
    second = Fiber.yield (first + 2)
end

puts fiber.resume 10
puts fiber.resume 14
puts fiber.resume 20
'''

require 'fiber'
fiber1 = Fiber.new do
    puts "In Fiber 1"
    Fiber.yield
  end
  
  fiber2 = Fiber.new do
    puts "In Fiber 2"
    fiber1.transfer
    puts "Never see this message"
  end
  
  fiber3 = Fiber.new do
    puts "In Fiber 3"
  end
  
  fiber2.resume
  fiber3.resume