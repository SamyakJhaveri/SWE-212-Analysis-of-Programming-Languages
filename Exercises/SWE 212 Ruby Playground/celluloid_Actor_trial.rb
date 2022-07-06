# With Reference to: 
# https://engineering.universe.com/introduction-to-concurrency-models-with-ruby-part-ii-c39c7e612bed
# https://engineering.universe.com/introduction-to-concurrency-models-with-ruby-part-i-550d0dbb970
# https://c7.se/intro-to-celluloid/

require "celluloid/autostart"
'''class Universe
    include Celluloid
    def say(msg)
        puts msg
        Celluloid::Actor[:world].say("#{msg} wORLD!")
    end
end

class World
    include Celluloid
    def say(msg)
        puts msg
    end
end

Celluloid::Actor[:world] = World.new
Universe.new.say("Hello from Universe")'''
# Reference to: https://www.youtube.com/watch?v=g2YR8ssSDKI
'''class Worker
    include Celluloid

    def say_hello
        puts "hello"
    end

    def say_goodbye
        puts "goodbye"
    end
end


class Dispatcher
    include Celluloid

    def run(worker) 
        loop do 
            sleep(1)
            action = [:say_hello, :say_goodbye].sample
            worker.async.send(action)
            puts "Producer pushing #{action}"
        end
    end
end

worker = Worker.pool
dispatcher = Dispatcher.new
dispatcher.async.run(worder)
sleep 20
'''
# Reference to : https://www.youtube.com/watch?v=N2A0TDRz5UM
'''
class Rocket
    include Celluloid

    def launch
        3.downto(1) do |n|
            puts "#{n}..."
            sleep 1
        end
        puts "Blast Off!"
    end
end

Rocket.new.launch
Rocket.new.launch
'''
# Reference to : https://web.archive.org/web/20130928093317/http://www.unlimitednovelty.com/2011/05/introducing-celluloid-concurrent-object.html
'''
class Quagmire
    include Celluloid

    def initialize(name)
        @name = name
        @status = :fired
    end

    def win
        @status = :winning
    end

    def current_status
        puts "#{@name} is #{@status}"
    end
end

glen = Quagmire.spawn "Glen Quagmire"
glen.current_status
glen.win!
glen.current_status
'''
# Reference to: https://github.com/celluloid/celluloid/blob/master/examples/basic_usage.rb
'''class Counter
    include Celluloid
    attr_reader :count
    def initialize
        @count = 0
    end

    def increment(n = 1)
        @count += n
    end
end

actor = Counter.new

puts actor.count

puts actor.increment

puts actor.async.increment(41)

puts actor.count
'''
# Reference to: https://github.com/celluloid/celluloid/blob/master/examples/stack.rb
'''
class Stack
    include Celluloid
    include Celluloid::Notifications
    attr_reader :ary

    def initialize
        @ary = []
    end
    
    def push(x)
        sleep(10)
        publish "done", "Slept for 10 secs I\'m awake now"
        @ary.push x
    end
    alias << push

    def pop
        @ary.pop
    end

    def show
        puts @ary
    end
end

st = Stack.new
st.async << 1 << 2 << 3

st.async.show

st.async.pop.pop

st.show
'''

'''class FilePutter
    include Celluloid
    def initialize(path_to_file)
        @file = path_to_file
    end

    def load_file
        @file_contents =  File.read @file #@file.read
    end

    def print
        puts @file_contents
    end

    def load_file_and_print
        @file_contents = File.read @file
        puts @file_contents
    end

end

files = ["../pride-and-prejudice.txt", "../stop_words.txt"]

files.each do |file|
    fp = FilePutter.spawn file
    fp.load_file_and_print
end
'''

'''class NotificationTest
    include Celluloid
    inclde Celluloid::Notifications

    def foo
        sleep(100)
        publish "done", "Slept for 10 seconds I\'m awake now"
    end
end

class Observer
    include Celluloid
    include Celluloid::Notifications

    def initialize
        subscibe "done", :on_completion
    end

    def on_completion(*args)
        puts args.inspect
    end
end'''

# Reference to: https://www.sitepoint.com/an-introduction-to-celluloid-part-ii/
class HelloSpaceActor
    include Celluloid

    def say_msg_1
        puts "Hello, from HelloSpaceActor (say_msg_1)"
        Celluloid::Actor[:world].say_msg_2
    end
end

class WorldActor
    include Celluloid
    def say_msg_2
        puts "world! from WorldActor (say_msg_2)"
        Celluloid::Actor[:newline].say_msg_3
    end
end

class NewlineActor
    include Celluloid

    def say_msg_3
        puts "\n from NewlineActor (say_msg_3)"
    end
end

Celluloid::Actor[:world] = WorldActor.new
Celluloid::Actor[:newline] = NewlineActor.new
HelloSpaceActor.new.say_msg_1