#
# Functions for map reduce
#
'''
References:
1. https://stackoverflow.com/questions/13271670/what-is-the-python-equivalent-of-map-in-ruby-and-javascript
2. https://howchoo.com/code/understand-the-map-function-in-python
3. https://www.stackovercloud.com/2020/08/04/how-to-use-the-python-map-function/
4. https://stackoverflow.com/questions/12084507/what-does-the-map-method-do-in-ruby
5. https://www.sethvargo.com/ruby-local-method-map-shortcut/
6. https://en.wikipedia.org/wiki/MapReduce
7. https://www.youtube.com/watch?v=meMHMTKVQSA



'''
require 'set'

def partition(data_str, nlines)
    """
    Partition the input data_str (a big string)
    into chunks of nlines. 
    """
    blocks = []
    sub_block = ""
    #lines = data_str.split('\n')
    
    temp = 1

    data_str.each_line do |line|
        if temp <= nlines 
            sub_block += line
            puts temp        
        elsif (temp > nlines)
            blocks << sub_block
            sub_block = ""
            temp = 1
        end
        temp += 1
    end
    return blocks

end

def _scan(str_data)
    return str_data.scan(/[a-z]{2,}/)
end

def _remove_stop_words(word_list)
    words_cleaned = []
    stops = ((IO.read '../stop_words.txt').split ',').to_set
    word_list.each {|word|
        if not stops.member?(word)
            words_cleaned.append(word)
        end
        }
    return words_cleaned
end
def split_words(data_block)
    """
    Takes a string, returns a list of pairs (word, 1),
    one for each word in the input, so
    [(w1, 1), (w2, 1), ..., (wn, 1)]
    """
    # The actual work of splitting the input into words
    result = []
    words = _remove_stop_words(_scan(data_block))
    words.each do |w|
        result << [w, 1]
    end
    return result
end

def count_words(pairs_list_1, pairs_list_2)
    """
    Takes two lists of pairs of the form 
    [(w1, 1), (w2, 1), ...]
    and returns a list of pairs [(w1, frequency), ...],
    where frequency is the sum of all the reported occurences
    """
    mapping = Hash.new(0)
    pairs_list_list = []
    #pairs_list_list = pairs_list_1.concat(pairs_list_2)
    pairs_list_list << pairs_list_1
    pairs_list_list << pairs_list_2
    pairs_list_list.each{|pl|
        pl.each{|p|
            #puts "pair:#{p}"
            if mapping.member?(p[0])
                mapping[p[0]] += p[1]
            else
                mapping[p[0]] = p[1]
            end
        }
    }
    return mapping
end

# 
# Auxiliary Functions
#
def read_file(path_to_file)
    #lines = File.readlines(path_to_file)
    return path_to_file.read.downcase # lines 
end

def sort(word_freq)
    word_freq.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
end

blocks = partition(read_file(ARGF), 200)
splits = blocks.map{|a| split_words(a)}
puts "Splits.length: #{splits.length}"

word_freqs = sort(splits.reduce{|pairs_list_1, pairs_list_2| count_words(pairs_list_1, pairs_list_2)})
