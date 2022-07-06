"""Style #28 Lazy Rivers
Implemented using Ruby's version of Generators i.e. Fibers. 
Please read the README of rmore information on how Ruby uses Fiers to implement Generators. 
Completed on: 15th May, 2022

Constraints:

Data comes to functions in streams, rather than as a complete whole all at at once
Functions are filters / transformers from one kind of data stream to another
Possible names:

Lazy rivers
Data streams
Dataflow
Data generators
"""
require 'set'
require 'fiber'

# instead of creating functions (like those present in Prof. Crista's example code),
# Fiber uses 'fiber' objects that can work just like generator functions - 
# 1. taking in arguments (filname)
# 2. performing tasks
# 3. 'yield'-ing results on-the-fly/during runtime

# Generator Fiber to yield lines from the given text
all_lines_fiber = Fiber.new do |filename|
    lines = []
    filename.read.downcase.each_line do |line|
        lines << line
    end
    Fiber.yield lines
end

# Generator Fiber to yield words of a line 
all_words_fiber = Fiber.new do |filename|
    lines = all_lines_fiber.resume(filename)
    words = []
    lines.each do |line|
        words.concat(line.scan(/[a-z]{2,}/))
    end
    Fiber.yield words
end

# Generator Fiber to yield non_stop_words
non_stop_words_fiber = Fiber.new do |filename|
    stops = ((IO.read "../../stop_words.txt").split ",").to_set
    aw = all_words_fiber.resume(filename)
    nsw = []
    aw.each do |w|
        if stops.member?(w) == false
            nsw << w
        end
    end
    Fiber.yield nsw
end

# Generator Fiber to yield word count dictionary
count_and_sort_fiber = Fiber.new do |filename|
    
    freqs = Hash.new(0)
    i = 1
    nsw = non_stop_words_fiber.resume(filename)
    nsw.each do |w|
        if freqs.member?(w) == false
            freqs[w] = 1
        else
            freqs[w] += 1
        end
    end
    Fiber.yield freqs #.sort_by{|w,c| -c}
end

# Here, `.resume()` is Ruby's equivalent to `calling` a generator in Python
result_freq = count_and_sort_fiber.resume(ARGF)
result_freq.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
