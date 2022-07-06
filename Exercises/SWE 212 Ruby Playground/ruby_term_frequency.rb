#!/usr/bin/env ruby
require 'set'

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
    stops = ((IO.read '../stop_words.txt').split ',').to_set
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

def sort_words(word_freqs)
    # word_freqs.sort_by{|w,c|-c}[0,25].each{|w,c|puts "#{w} - #{c}"}
    word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
end

sort_words(frequencies(remove_stop_words(get_words(read_file(ARGF)))))