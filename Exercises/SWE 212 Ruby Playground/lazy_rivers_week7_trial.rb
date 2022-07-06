require 'set'

'''
def all_words(filename)
    words = filename.read.downcase.scan(/[a-z]{2,}/)
    yield words
end

def non_stop_words(filename)
    stops = ((IO.read "../stop_words.txt").split ",").to_set
    all_words(filename).each do |word|
        if stops.member?(word) == false
            yield word
        end
    end
end

def count_and_sort(filename)
    freqs = Hash.new(0)
    i = 1
    non_stop_words(filename).each do |word|
        if freqs.member?(word) == false
            freqs[word] = 1
        else
            freqs[word] += 1
        end
        if i % 5000 == 0
            yield freqs.sort_by{|w,c| -c}
        end
        i += 1
    end
    yield freqs.sort_by{|w,c| -c }
end

count_and_sort(ARGF).each do |word_freqs|
    puts "-------------------------"
    word_freqs[0, 25].each{|w, c| puts "#{w} - #{c}"}
end

'''
require 'fiber'

def all_lines(filename)
    puts filename
    file = File.open(filename, 'r')
    Fiber.new do
        lines = []
        file.read.each_line do |line|
            Fiber.yield line.downcase
        end
    end
    file.close
end

'''
all_lines_fiber = Fiber.new do |filename|
    lines = []
    filename.read.downcase.each_line do |line|
        lines << line
    end
    Fiber.yield lines
end
'''

def all_words(filename)
    Fiber.new do
        loop do
            line = all_lines(filename).resume
            Fiber.yield line.scan(/[a-z]{2,}/)
        end
    end
end
'''
all_words_fiber = Fiber.new do |filename|
    lines = all_lines_fiber.resume(filename)
    words = []
    lines.each do |line|
        words.concat(line.scan(/[a-z]{2,}/))
    end
    #words << lines.scan(/[a-z]{2,}/)
    """lines.each do |line|
        words = line."""
    Fiber.yield words
end
'''

def non_stop_words(filename)
    Fiber.new do
        stops = ((IO.read "../stop_words.txt").split ",").to_set
        all_words(filename).resume.each do |w|
            w = all_words(filename).resume
            Fiber.yield (w if (stops.member?(w) == false))
        end
    end
end

'''
non_stop_words_fiber = Fiber.new do |filename|
    stops = ((IO.read "../stop_words.txt").split ",").to_set
    aw = all_words_fiber.resume(filename)
    nsw = []
    aw.each do |w|
        if stops.member?(w) == false
            nsw << w
        end
    end
    Fiber.yield nsw
end
'''

def count_and_sort(filename)
    Fiber.new do
        freqs = Hash.new(0)
        i = 1
        non_stop_words(filename).resume.each do |word|
            if (freqs.member?(word) == false)
                freqs[word] = 1 
            else 
                freqs[word] += 1
            end

        end
        Fiber.yield freqs
    end
end
'''
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
        """if i % 5000 == 0
            Fiber.yield freqs
        end
        i += 1"""
    end
    Fiber.yield freqs #.sort_by{|w,c| -c}
end
'''


'''result_freq = count_and_sort_fiber.resume(ARGF)
puts "Result Freq: #{result_freq}"
result_freq.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
'''

loop do
    count_and_sort(ARGF).resume.each do |word_freqs|
        puts word_freqs.class
        puts "-------------------------"
        word_freqs.sort_by{|w,c| -c }[0, 25].each{|w, c| puts "#{w} - #{c}"}
    end    
end

