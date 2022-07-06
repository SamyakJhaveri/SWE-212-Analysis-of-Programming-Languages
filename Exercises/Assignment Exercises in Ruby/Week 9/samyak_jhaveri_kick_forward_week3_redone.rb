"""Style #9 Kick Forward Styel Redone for Week 9 
Completed on 29th May 2022

Variation of the candy factory style, with the following additional constraints:

Each function takes an additional parameter, usually the last, which is another function
That function parameter is applied at the end of the current function
That function parameter is given as input what would be the output of the current function
Larger problem is solved as a pipeline of functions, but where the next function to be applied is given as parameter to the current function
Possible names:

Kick your teammate forward!
Continuation-passing style
Crochet looprequire 'set'
"""

def read_file(path_to_file, f)
    text = path_to_file.read.downcase
    f.call(text, method(:remove_stop_words))
end

def get_words(text, f)
    words = text.scan(/[a-z]{2,}/)
    f.call(words, method(:frequencies))
end
    
def remove_stop_words(words, f)
    words_cleaned = []
    stops = ((IO.read '../stop_words.txt').split ',').to_set
    words.each {|word|
        if not stops.member?(word)
            words_cleaned.append(word)
        end
        }
    f.call(words_cleaned, method(:sort_words))
end

def frequencies(words_cleaned, f)
    word_freqs = Hash.new(0)

    words_cleaned.each {|word|
        word_freqs[word] += 1
    }
    f.call(word_freqs)
end

def sort_words(word_freqs)
    word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
end

read_file(ARGF, method(:get_words))