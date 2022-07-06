"""
Style #27
Completed 27.1 on : 11th May 2022
Completed 27.2 on : 14th May 2022
Constraints:

The problem is modeled like a spreadsheet, with columns of data and formulas

Some data depends on other data according to formulas. When data changes, the dependent data also changes automatically.

Possible names:

Spreadsheet
Dataflow
Active data
"""
require 'set'

#
# The columns. Each column is a data element and a formula.
# The first 2 columns are the input data, so no formulas.
#
all_words = [[], nil]
stop_words = [[], nil]

# Column with all the words, but with the stopwords replaced with  ""
non_stop_words = [[], -> {all_words[0].each{|word|
    if stop_words[0].member?(word) == false
        non_stop_words[0] << word
    else
        next
    end
}}]

# Column with list of all unique non_stop words
unique_words = [[], ->{unique_words[0] << non_stop_words[0].to_set.to_a}]

# Column with the unique, non_stop_words and their corresponding frequencies
counts = [Hash.new(0), -> {
    non_stop_words[0].each {|word|
        counts[0][word] += 1}
    }
]

# Column with all the unique, non_stop words and their corresponding frequencies
# sorted in descending order of frequencies
sorted_data = [[], -> {sorted_data[0] = counts[0].sort_by{|w,c| -c}}]


# Load the fixed data into the first 2 columns
stop_words[0] = ((IO.read '../../stop_words.txt').split ',').to_set

# The entire spreadsheet
$all_columns = [all_words, stop_words, non_stop_words,\
    unique_words, counts, sorted_data]


def update
    # Apply the formula in each column
    $all_columns.each do |col|
        if col[1] != nil
            #col[0] =
			col[1].call()
        end
    end
end


puts "Please input the file paths of the text files you want to see results of\nvia the command line."
puts "For example: ruby TwentySeven.rb ../pride-and-prejudice.txt ../on-the-origin-of-species.txt"
puts "Note: When passing file paths as command line arguments, please make sure to include the pride and prejudice text file."
input_array_of_file_paths = ARGV
if input_array_of_file_paths.length >= 1
    puts "You added #{input_array_of_file_paths.length} files"
    input_array_of_file_paths.each do |file_path|
        file = File.open(file_path, 'r')
        all_words[0].concat(file.read.downcase.scan(/[a-z]{2,}/))
        file.close
    end
else
    puts "Too few argumnts"
end

# Update the columns with formulas
update()

sorted_data[0][0, 25].each{|w, c| puts "#{w} - #{c}"}