'''
Style #30
Completed on 9th May 2022
Constraints:

Existence of one or more units that execute concurrently

Existence of one or more data spaces where concurrent units store and retrieve data

No direct data exchanges between the concurrent units, other than via the data spaces

Possible names:

Dataspaces
Linda
'''
require 'set'
require 'celluloid/autostart'
stopwords = ((IO.read '../../stop_words.txt').split ',').to_set

# Two data spaces
word_space = Queue.new
freq_space = Queue.new

# Let's have this thread populate the word_space
words = ARGF.read.downcase.scan(/[a-z]{2,}/)
words.each{|word|
    word_space << word
}


# Let's have the workers andlaunch them at their jobs
# Ruby's in-built Thread Queue implementation does not allow functions executed by threads to 
# access 'word_space' and 'freq_space' dataspaces. However, the conceptual integrity of the
# this program in Ruby is maintained by executing the tasks directly inside the Thread loop. 
start = Time.now
workers = []
5.times do
    workers << Celluloid::Future.new { 
        # Worker funciton that consumes words for mthe word space
        # and sends the partial results to the frequency space

        sleep(1)
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


diff = Time.now.to_f - start.to_f
puts ("#{diff} seconds to complete")

# Lets merge the partial frequency results by consuming
# frequency data from the frequency space
word_freqs = Hash.new(0)
word_freqs = freq_space.pop

word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}