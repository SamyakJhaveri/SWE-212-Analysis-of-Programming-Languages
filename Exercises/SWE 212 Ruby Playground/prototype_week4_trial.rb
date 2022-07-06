require 'set'

def extract_words(obj, path_to_file)
    obj["data"] = path_to_file.read.downcase.scan(/[a-z]{2,}/)
end

def load_stop_words(obj)
    obj["stop_words"] = ((IO.read '../stop_words.txt').split ',').to_set
    # obj["stop_words"] = obj["stop_words"].concat(('a'..'z').to_a) #String.ascii_lowercase.chars())
    obj["stop_words"] += ('a'..'z').to_a
end

def increment_count(obj, w)
    if not obj["freqs"].member?(w)
        obj["freqs"][w] = 1
    else
        obj["freqs"][w] += 1
    end
end


data_storage_obj = Hash[
    "data" => [],
    "init" => -> (path_to_file) {extract_words(data_storage_obj, path_to_file)}, 
    "words" => -> {data_storage_obj["data"]}
]

stop_words_obj = Hash[
    "stop_words" => [],
    "init" =>  -> {load_stop_words(stop_words_obj)},
    "is_stop_word" => -> (word) {stop_words_obj["stop_words"].member?(word)}
]

word_freqs_obj = Hash[
    "freqs" => Hash.new(0),
    "increment_count" => ->(w) {increment_count(word_freqs_obj, w)},
    "sorted" => -> {word_freqs_obj["freqs"].sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}}
]

#
# The main section
#

data_storage_obj["init"].call(ARGF)
stop_words_obj["init"].call

'''@_storage_manager.dispatch(["words"]).each {|word|
            if not @_stop_word_manager.dispatch(["is_stop_word", word])
                @_word_freq_manager.dispatch(["increment_count", word])
            end
        }'''

data_storage_obj["words"].call.each{|w|
    if not stop_words_obj["is_stop_word"].call(w)
        word_freqs_obj["increment_count"].call(w)
    end
}

# local_word_freqs = 
word_freqs_obj["sorted"].call
# local_word_freqs.each{|w, c| puts "#{w} - #{c}"}

