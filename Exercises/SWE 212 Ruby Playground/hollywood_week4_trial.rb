"""
Style #15

Constraints:

Larger problem is decomposed into entities using some form of abstraction (objects, modules or similar)

The entities are never called on directly for actions

The entities provide interfaces for other entities to be able to register callbacks

At certain points of the computation, the entities call on the other entities that have registered for callbacks

Possible names:

Hollywood agent: don't call us, we'll call you
Inversion of control
Callback heaven/hell
"""
require 'set'



class DataStorage
    @_data = []
    @_stop_word_filter = nil
    @_word_event_handlers = []

    def initialize(wfapp, stop_word_filter)
        @_stop_word_filter = stop_word_filter
        wfapp.register_for_load_event(method(:__load))
        wfapp.register_for_dowork_event(method(:__produce_words))
    end
    
    def __load(path_to_file)
        @_data = path_to_file.read.downcase.scan(/[a-z]{2,}/)
    end

    def __produce_words
        @_data.each{|word|
            if not @_stop_word_filter.is_stop_word(word)
                @_word_event_handlers.each{|h|
                    h.call(word)
                }
            end
        }
    end

    def register_for_word_event(handler_function)
        @_word_event_handlers = (handler_function)
    end
end

class StopWordFilter
    @_stop_words = []

    def initialize(wfapp)
        wfapp.register_for_load_event(method(:__load))
    end

    def __load
        @_stop_words = ((IO.read '../stop_words.txt').split ',').to_set 
        # add single-letter words
        @_stop_words += ('a'..'z').to_a
    end

    def is_stop_word(word)
        return (@_stop_words.member?(word))
    end
end

class WordFrequencyCounter
    @_word_freqs = Hash.new(0)

    def initialize(wfapp, data_storage)
        data_storage.register_for_word_event(method(:__increment_count))
        wfapp.register_for_end_event(method(:__print_freqs))
    end

    def __increment_count(word)
        if @_word_freqs.member?(word)
            @_word_freqs[word] += 1
        else
            @_word_freqs[word] = 1
        end
    end

    def __print_freqs
        @_word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
    end
end

class WordFrequencyFramework
    @_load_event_handlers = []
    @_dowork_event_handlers = []
    @_end_event_handlers = []
    puts @_load_event_handlers

    def register_for_load_event(handler_function)
        puts handler_function.class
        @_load_event_handlers = handler_function
    end

    def register_for_dowork_event(handler_function)
        @_dowork_event_handlers = (handler_function)
    end

    def register_for_end_event(handler_function)
        @_end_event_handlers = (handler_function)
    end

    def run(path_to_file)
        @_load_event_handlers.each{|h|
            h.call(path_to_file)
        }
        @_dowork_event_handlers.each{|h|
            h.call
        }
        @_end_event_handlers.each{|h|
            h.call
        }
    end
end



wfapp = WordFrequencyFramework.new
stop_word_filter = StopWordFilter.new(wfapp)
data_storage = DataStorage.new(wfapp, stop_word_filter)
word_freq_counter = WordFrequencyCounter.new(wfapp, data_storage)
wfapp.run(ARGF)