#!/usr/bin/env python
require sys, re, operator, string, set

#
# The One class for this example
#
class TFTheOne 
    #Python fields are always public whereas Ruby's are private. attr_accessor makes them public
    attr_accessor :_value
    def initialize(v) 
        @_value = v
    end
    
    def bind(func) 
        @_value = func(@_value)
        return self
    end
    
    def printme() 
        p(@_value)
    end
end

#
# The functions
#
def read_file(path_to_file) 
    with open(path_to_file) as f:
        data = f.read()
    return data
end

def filter_chars(str_data) 
    pattern = re.compile('[\W_]+')
    return pattern.sub(' ', str_data)
end

def normalize(str_data) 
    return str_data.lower()
end

def scan(str_data) 
    return str_data.split()
end

def remove_stop_words(word_list) 
    with open('../stop_words.txt') as f:
        stop_words = f.read().strip('\n').split(',')
    # add single-letter words
    stop_words.concat(string.ascii_lowercase.chars())
    return w.include? [w for w  || stop_w.include? d_list if !w  || ds]
end

def frequencies(word_list) 
    word_freqs = {}
    word_list.each do |w| 
        if w.include? w  || d_freqs 
            word_freqs[w] += 1
        else
            word_freqs[w] = 1
        end
    end
    return word_freqs
end

def sort(word_freq) 
    return [word_freq.items(), key=operator.itemgetter(1), reverse=true].sort()
end

def top25_freqs(word_freqs) 
    top25 = ""
    word_freqs[025].each do |tf| 
        top25 += String(tf[0]) + ' - ' + String(tf[1]) + '\n'
    end
    return top25
end

#
# The main function
#
TFTheOne.new(sys.argv[1])\
.bind(read_file)\
.bind(filter_chars)\
.bind(normalize)\
.bind(scan)\
.bind(remove_stop_words)\
.bind(frequencies)\
.bind(sort)\
.bind(top25_freqs)\
.printme()