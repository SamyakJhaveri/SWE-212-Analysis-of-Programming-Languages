'''array = [1, 2, 3]
puts array.map{|n| n * 2}
puts array
puts array.collect{|n| n*2}
puts array
'''
hash = {whey: "protein", apple: "fruit"}

# .map{} always returns an array
'''puts hash.map{|key, value|
    value.size
}'''

# This returns an array of arrays
# Like so:
# [[:whey, protein], [:apple, fruit]]
puts hash.map{|key, value|
[key, value.size]
}

# This convets the returned array into a hash
# the hash returned is f the form:
# {:whey=>7, :apple=>5}
puts hash.map{|key, value|
    [key, value.size]
}.to_h