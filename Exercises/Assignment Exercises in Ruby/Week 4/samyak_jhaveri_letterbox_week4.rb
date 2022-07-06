"""
Style #12
Completed on: 19th April 2022
Constraints:

The larger problem is decomposed into 'things' that make sense for the problem domain

Each 'thing' is a capsule of data that exposes one single procedure, namely the ability to receive and dispatch messages that are sent to it

Message dispatch can result in sending the message to another capsule

Possible names:

Letterbox
Messaging style
Objects
Actors
"""

require 'set'

class DataStorageManager
    """ Models the contents of the file """
    @_data = " "

    def dispatch(message)
        if message[0] == "init"
            return _init(message[1])
        elsif message[0] == "words"
            return _words   
       else
        raise StandardError.new "Message not Understood" + message[0]
       end
    end
    
    def _init(path_to_file)
        @_data = path_to_file.read.downcase
    end
    
    def _words
        words = @_data.scan(/[a-z]{2,}/)
        return words
    end

end

class StopWordManager
    """ Models the stop word filter """

    @_stop_words = []

    def dispatch(message)
        if message[0] == "init"
            return _init()
        elsif message[0] == "remove_stop_words"
            return _remove_stop_words(message[1])
        else
            raise StandardError.new "Message not Understood" + message[0]
        end
    end

    def _init()
        @_stop_words = ((IO.read '../../stop_words.txt').split ',').to_set
    end

    def _remove_stop_words(words)
        words_cleaned = []
        words.each {|word|
            if not @_stop_words.member?(word)
                words_cleaned.append(word)
            end
            }
        return words_cleaned
    end
end

class WordFrequencyManager
    """ Keeps the word frequency data """

    def dispatch(message)
        if message[0] == "increment_count"
            return _increment_count(message[1])
        elsif message[0] == "sorted"
            return _sorted(message[1])
        else
            raise StandardError.new "Message not Understood" + message[0]
        end
    end

    def _increment_count(word)
        # @_word_freqs[word] += 1

        if @_word_freqs.key?(word)
            @_word_freqs[word] += 1
        else
            @_word_freqs[word] = 1
        end
    end

    def _sorted(wfs)
        return (wfs.sort_by{|w,c| -c }[0, 25])
    end
end

class WordFrequencyController
    """ Keeps the word frequency data """

    def dispatch(message)
        if message[0] == "init"
            return _init(message[1])
        elsif message[0] == "run"
            return _run
        else
            raise StandardError.new "Message not Understood" + message[0]
        end
    end

    def _init(path_to_file)
        @_storage_manager = DataStorageManager. new
        @_stop_word_manager = StopWordManager. new
        @_word_freq_manager = WordFrequencyManager. new        
        @_storage_manager.dispatch(["init", path_to_file])
        @_stop_word_manager.dispatch(["init"])
    end

    def _run
        words = @_storage_manager.dispatch(["words"])
        words_cleaned = @_stop_word_manager.dispatch(["remove_stop_words", words])
        local_word_freqs = Hash.new(0)

        words_cleaned.each {|word|
            local_word_freqs[word] += 1
        }

        local_word_freqs = @_word_freq_manager.dispatch(["sorted", local_word_freqs])
        local_word_freqs.each{|w, c| puts "#{w} - #{c}"}
    end
end

#
#   the main function
#
wfcontroller = WordFrequencyController. new
wfcontroller.dispatch(["init", ARGF])
wfcontroller.dispatch(["run"])
