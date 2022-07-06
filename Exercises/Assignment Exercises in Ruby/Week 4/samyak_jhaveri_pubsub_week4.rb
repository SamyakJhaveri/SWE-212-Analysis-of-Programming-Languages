"""
Style #16
Completed on: 16.1 on 24th April 2022, 16.2 on 25th April 2022

Constraints:

Larger problem is decomposed into entities using some form of abstraction (objects, modules or similar)

The entities are never called on directly for actions

Existence of an infrastructure for publishing and subscribing to events, aka the bulletin board

Entities post event subscriptions (aka 'wanted') to the bulletin board and publish events (aka 'offered') to the bulletin board. the bulletin board does all the event management and distribution

Possible names:

Bulletin board
Publish-Subscribe
"""

require 'set'

#
# The event management substrate
#
class EventManager
    def initialize
        @_subscriptions = Hash.new [] 
    end

    def subscribe(event_type, handler_function)
        @_subscriptions[event_type] += [handler_function]
        
    end

    def publish(event)
        event_type = event[0]
        if @_subscriptions.key?(event_type)
            @_subscriptions[event_type].each {|hf|
                hf.call(event)
            }
            
        end
    end
end

#
# The application entities
#
class DataStorage
    """ Models the contents of the file """

    @_data = " "
    def initialize(event_manager)
        @_event_manager = event_manager
        @_event_manager.subscribe("load", method(:load_text))
        @_event_manager.subscribe("start", method(:produce_words))
    end

    def load_text(event)
        path_to_file = event[1]
        @_data = path_to_file.read.downcase
    end

    def produce_words(event)
        data_str = @_data.scan(/[a-z]{2,}/)
        data_str.each{|word|
            @_event_manager.publish(["word", word])
        }
        @_event_manager.publish(["eof", nil])
    end
end

class StopWordFilter
    """ Models the stop word filter """

    def initialize(event_manager)
        @_stop_words = []
        @_event_manager = event_manager
        @_event_manager.subscribe("load", method(:load_sw))
        @_event_manager.subscribe("word", method(:is_stop_word))
    end

    def load_sw(event)
        @_stop_words = ((IO.read '../../stop_words.txt').split ',').to_set 
        # add single-letter words
        @_stop_words += ('a'..'z').to_a
    end

    def is_stop_word(event)
        word = event[1]
        if not @_stop_words.member?(word)
            @_event_manager.publish(["valid_word", word])
        end
    end
end

class WordFrequencyCounter
    """ Keeps the word frequency data """

    def initialize(event_manager)
        @_word_freqs = Hash.new
        @_event_manager = event_manager
        @_event_manager.subscribe("valid_word", method(:increment_count))
        @_event_manager.subscribe("print", method(:print_freqs))
    end

    def increment_count(event)
        word = event[1]        
        if @_word_freqs.member?(word)
            @_word_freqs[word] += 1
        else
            @_word_freqs[word] = 1
        end
    end

    def print_freqs(event)
        @_word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
    end
end

class WordFrequencyApplication
    def initialize(event_manager)
        @_event_manager = event_manager
        @_event_manager.subscribe("run", method(:run)) 
        @_event_manager.subscribe("eof", method(:stop))
    end

    def run(event)
        path_to_file = event[1]
        @_event_manager.publish(["load", path_to_file])
        @_event_manager.publish(["start", nil])
    end

    def stop(event)
        @_event_manager.publish(["print", nil])
    end
end

class WordsWithZClass
    """ Manages the counting of words iwth the letter 'z' in them """

    def initialize(event_manager)
        @_words_with_z = []
        @_event_manager = event_manager
        @_event_manager.subscribe("valid_word", method(:increment_z_count))
        @_event_manager.subscribe("print", method(:print_zcounts))
    end

    def increment_z_count(event)
        word = event[1]
        if word.include?("z")
            if not @_words_with_z.member?(word)
                @_words_with_z.append(word) 
            end
        end
    end

    def print_zcounts(event)
        puts "Number of Non-Stop Words with the letter 'z' in them:"
        puts @_words_with_z.length()
    end
end

#
# The main function
#
em = EventManager. new
DataStorage.new(em)
StopWordFilter.new(em)
WordFrequencyCounter.new(em)
WordFrequencyApplication.new(em)
WordsWithZClass.new(em)
em.publish(["run", ARGF])
