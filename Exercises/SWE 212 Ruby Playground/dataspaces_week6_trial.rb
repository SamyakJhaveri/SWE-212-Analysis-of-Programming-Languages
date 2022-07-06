# https://ruby-doc.org/core-2.5.0/Queue.html
require 'set'
require 'celluloid/autostart'
stopwords = ((IO.read '../stop_words.txt').split ',').to_set

# Two data spaces
word_space = Queue.new
freq_space = Queue.new

# Let's have this thread populate the word_space
words = ARGF.read.downcase.scan(/[a-z]{2,}/)
words.each{|word|
    word_space << word
}

# Worker funciton that consumes words for mthe word space
# and sends the partial results to the frequency space
class WF
    include Celluloid
    def process_words
        local_word_freqs = Hash.new(0)
        sleep(1)

        while true do
            if ((word_space.empty?) == false)
                begin
                    word = word_space.pop
                rescue
                    puts "Error in getting word from word_space"
                end
            else
                break
            end

            if not stopwords.member?(word)
                if local_word_freqs.member?(word)
                    word_freqs[word] += 1
                else
                    local_word_freqs[word] = 1
                end
            end
        end
        freq_space << local_word_freqs
    end
end


# Let's have the workers andlaunch them at their jobs
# Ruby's in-built Thread Queue implementation does not allow functions executed by threads to 
# access 'word_space' and 'freq_space' dataspaces. However, the conceptual integrity of the
# this program in Ruby is maintained by executing the tasks directly inside the Thread loop. 
# https://www.youtube.com/watch?v=BWQsZUyZKGY
start = Time.now
workers = []
5.times do
    workers << Celluloid::Future.new { 
        #Thread.new do
        sleep(1)
        # WF.new.process_words
        # the work that the Worker performs
        # queue.push([action, paylod])
        local_word_freqs = Hash.new(0)
        while true do
            if ((word_space.empty?) == false)
                begin
                    word = word_space.pop
                rescue
                    puts "Error in getting word from word_space"
                end
            else
                break
            end

            if not stopwords.member?(word)
                if local_word_freqs.member?(word)
                    local_word_freqs[word] += 1
                else
                    local_word_freqs[word] = 1
                end
            end
        end
        freq_space << local_word_freqs
    }
end

#workers.each(&:join)

workers.each{|t|
    t.join
}
workers.each{|w| p w.value}


diff = Time.now.to_f - start.to_f
puts ("#{diff} seconds to complete")

# Lets merge the partial frequency results by consuming
# frequency data from the frequency space
word_freqs = Hash.new(0)
word_freqs = freq_space.pop

word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}

