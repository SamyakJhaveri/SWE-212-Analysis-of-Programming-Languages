# Trying threading in Ruby 
# First Attempt in Actors style. 
# With referecences to : 
# 1) https://www.educba.com/thread-in-ruby/
'''class Worker
    def initialize(num_threads:)
        @num_threads = num_threads
        @threads = []
        @queue = Queue.new
    end

    attr_reader :num_threads, :threads
    private :threads

    def spawn_threads
        num_threads.times do
            threads << Thread.new do
                # the work that the Worker performs
            end
        end
    end

    def enqueue(action, payload)
        queue.push([action, paylod])
    end
end'''
# Basics of Threading in Ruby
# Example 1

'''def school1
    counter1 = 0
    while counter1 <= 2
        puts "Class1 started at : #{Time.now}"
        sleep(2)
        counter1 += 1
    end
end

def school2
    counter2 = 0
    while counter2 <= 2
        puts "Class2 started at #{Time.now}"
        sleep(1)
        counter2 += 1
    end
end

puts "Common class started at: #{Time.now}"
school1Thread = Thread.new{school1}
school2Thread = Thread.new{school2}
school1Thread.join
school2Thread.join
puts "Finally, classes end at #{Time.now}"
'''

# Example 2
require 'thread'

a = b = 0
subtraction = 0
Thread.new do
    loop do
        a += 1
        b += 1
    end
end

Thread.new do
    loop do
        subtraction += (a - b).abs
    end
end
sleep 1
puts "The Value of a is: #{a}"
puts "The Value of b is: #{b}"
puts "The Value of subtraction is: #{subtraction}"
