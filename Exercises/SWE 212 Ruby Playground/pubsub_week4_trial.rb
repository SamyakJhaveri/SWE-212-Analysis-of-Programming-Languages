require 'set'

class EventManager
    def initialize
        @_subscriptions = Hash.new [] #{|et,f| et[f]=[]}
    end
    # (hash[key] ||= []) << value

    def subscribe(event_type, handler_function)
        @_subscriptions[event_type] += [handler_function]
        '''if @_subscriptions.key?(event_type)
            
            @_subscriptions[event_type] += [handler_function]
        else
            puts "handler_function"
            puts handler_function
            @_subscriptions[event_type] << [handler_function]
            puts "subscriptions"
            puts (@_subscriptions)

        end'''
    end

    def publish(event)
        event_type = event[0]
        #puts "Subscriptions"
        #puts @_subscriptions
        if @_subscriptions.key?(event_type)
            @_subscriptions[event_type].each {|hf|
                # send(hf, event)
                # method_string_name = hf.to_s
                # puts "Method String Name:"
                # puts method_string_name
                hf.call(event)
            }
            
        end
    end
end

class DataStorage
    @_data = " "
    def initialize(event_manager)
        @_event_manager = event_manager
        @_event_manager.subscribe("load", method(:load_text))
        @_event_manager.subscribe("start", method(:produce_words))
    end

    def load_text(event)
        puts "load_text gets called 11"
        path_to_file = event[1]
        @_data = path_to_file.read.downcase
    end

    def produce_words(event)
        puts "produce_words gets called 22"
        data_str = @_data.scan(/[a-z]{2,}/)
        data_str.each{|word|
            @_event_manager.publish(["word", word])
        }
        @_event_manager.publish(["eof", nil])
    end
end

class StopWordFilter
    def initialize(event_manager)
        @_stop_words = []
        @_event_manager = event_manager
        @_event_manager.subscribe("load", method(:load_sw))
        @_event_manager.subscribe("word", method(:is_stop_word))
    end

    def load_sw(event)
        puts "load_sw gets called 33"
        @_stop_words = ((IO.read '../stop_words.txt').split ',').to_set 
        # add single-letter words
        @_stop_words += ('a'..'z').to_a
    end

    def is_stop_word(event)
        puts "is_stop_word gets called 44"
        word = event[1]
        if not @_stop_words.member?(word)
            @_event_manager.publish(["valid_word", word])
        end
    end
end

class WordFrequencyCounter
    def initialize(event_manager)
        @_word_freqs = Hash.new
        @_event_manager = event_manager
        @_event_manager.subscribe("valid_word", method(:increment_count))
        @_event_manager.subscribe("print", method(:print_freqs))
    end

    def increment_count(event)
        puts "increment count gets called 55"
        word = event[1]
        puts "word:"
        puts word
        #@_word_freqs[word] += 1
        
        if @_word_freqs.member?(word)
            @_word_freqs[word] += 1
        else
            @_word_freqs[word] = 1
        end
        
    end

    def print_freqs(event)
        puts "print_freqs gets called 66"
        puts "@_word_freqs"
        puts @_word_freqs
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
        puts "run gets called 77"
        path_to_file = event[1]
        @_event_manager.publish(["load", path_to_file])
        @_event_manager.publish(["start", nil])
    end

    def stop(event)
        puts "stop gets called 88"
        @_event_manager.publish(["print", nil])
    end
end

em = EventManager. new
DataStorage.new(em)
StopWordFilter.new(em)
WordFrequencyCounter.new(em)
WordFrequencyApplication.new(em)
em.publish(["run", ARGF])
