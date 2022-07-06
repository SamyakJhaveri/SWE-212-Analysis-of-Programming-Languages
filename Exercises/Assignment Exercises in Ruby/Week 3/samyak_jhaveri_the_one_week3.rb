"""
Style #10

Constraints:

Existence of an abstraction to which values can be converted.

This abstraction provides operations to (1) wrap around values, so that they become the abstraction; (2) bind itself to functions, so to establish sequences of functions; and (3) unwrap the value, so to examine the final result.

Larger problem is solved as a pipeline of functions bound together, with unwrapping happening at the end.

Particularly for The One style, the bind operation simply calls the given function, giving it the value that it holds, and holds on to the returned value.

Possible names:

The One
Monadic Identity
The wrapper of all things
Imperative functional style
"""
require 'set'

class TFTheOne
    def initialize(v)
        @_value = v
    end

    def bind(func)        
        @_value = func.call(@_value)
        return self
    end

    def printme()
        puts @_value
    end
end

def read_file(path_to_file)
    text = path_to_file.read.downcase
    return text
end

def get_words(text)
    words = text.scan(/[a-z]{2,}/)
    return words
end

def remove_stop_words(words)
    words_cleaned = []
    stops = ((IO.read '../../stop_words.txt').split ',').to_set
    words.each {|word|
        if not stops.member?(word)
            words_cleaned.append(word)
        end
        }
    return words_cleaned
end

def frequencies(words_cleaned)
    word_freqs = Hash.new(0)

    words_cleaned.each {|word|
        word_freqs[word] += 1
    }
    return word_freqs
end

def sort(word_freqs) 
    return word_freqs.sort_by{|w,c| -c }
end

def top25_freqs(word_freqs) 
    top25 = ""
    word_freqs[0, 25].each{|w, c| 
        top25 += "#{w} - #{c}" + "\n"}
    return top25
end

#
# The main function
#
TFTheOne.new(ARGF)\
.bind(method(:read_file))\
.bind(method(:get_words))\
.bind(method(:remove_stop_words))\
.bind(method(:frequencies))\
.bind(method(:sort))\
.bind(method(:top25_freqs))\
.printme()

#bind(read_file(ARGF)).bind(get_words).bind(remove_stop_words).bind(frequencies).bind(sort).bind(top25_freqs).printme()
# sort_words(frequencies(remove_stop_words(get_words(read_file(ARGF)))))
