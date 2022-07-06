"""
Style #3 Arrays
Completed on : May 23rd 2022
"""

import sys, string
import numpy as np
import re

def is_vowel(c):
    if c == "A" or c == "E" or c == "I" or c == "O" or c == "U":
        return True
    else:
        return False

# Example input: "Hello  World!" 
characters = np.array([' ']+list(open(sys.argv[1]).read())+[' '])
# Result: array([' ', 'H', 'e', 'l', 'l', 'o', ' ', ' ', 
#           'W', 'o', 'r', 'l', 'd', '!', ' '], dtype='<U1')

# Normalize
characters[~np.char.isalpha(characters)] = ' '
characters = np.char.upper(characters)
# Result: array([' ', 'h', 'e', 'l', 'l', 'o', ' ', ' ', 
#           'w', 'o', 'r', 'l', 'd', ' ', ' '], dtype='<U1')

charMapping = {"A": "4", 
                "E": "€", 
                "I": "|", 
                "O": "Θ", 
                "U": "µ"
                }

### Split the words by finding the indices of spaces
sp = np.where(characters == ' ') # (characters == ' ') 
# Result: (array([ 0, 6, 7, 13, 14], dtype=int64),)
# A little trick: let's double each index, and then take pairs

sp2 = np.repeat(sp, 2)
# Result: array([ 0, 0, 6, 6, 7, 7, 13, 13, 14, 14], dtype=int64)
# Get the pairs as a 2D matrix, skip the first and the last
w_ranges = np.reshape(sp2[1:-1], (-1, 2))
# Result: array([[ 0,  6],
#                [ 6,  7],
#                [ 7, 13],
#                [13, 14]], dtype=int64)
# Remove the indexing to the spaces themselves
w_ranges = w_ranges[np.where(w_ranges[:, 1] - w_ranges[:, 0] > 2)]
# Result: array([[ 0,  6],
#                [ 7, 13]], dtype=int64)

# Voila! Words are in between spaces, given as pairs of indices
words = list(map(lambda r: characters[r[0]:r[1]], w_ranges)) # list(map(lambda r: characters[r[0]:r[1]], w_ranges))
# Result: [array([' ', 'h', 'e', 'l', 'l', 'o'], dtype='<U1'), 
#          array([' ', 'w', 'o', 'r', 'l', 'd'], dtype='<U1')]

# Let's recode the characters as strings
swords = np.array(list(map(lambda w: ''.join(w).strip(), words)))
# Result: array(['hello', 'world'], dtype='<U5')

# Next, let's remove stop words
stop_words = np.array(list(set(open('../../stop_words.txt').read().split(','))))
Ustop_words = list(map((lambda w: np.char.upper(w)), stop_words))
ns_words = swords[~np.isin(swords, Ustop_words)]

ns_words2 = list(map(lambda w: w if len(w) >= 2 else "", ns_words))

def generate_leet(word):
    newChars = map((lambda x: charMapping[x] if(is_vowel(x)) else x), word)
    return ("".join(newChars))

leeted_ns_words = list(map(lambda w: generate_leet(w), ns_words2))

### Finally, count the word occurrences
uniq, counts = np.unique(leeted_ns_words, axis=0, return_counts=True)

wf_sorted = sorted(zip(uniq, counts), key=lambda t: t[1], reverse=True)
for w, c in wf_sorted[:25]:
    print(w, '-', c)

ngrams = zip(*[leeted_ns_words[i:] for i in range(2)])

ngrams_words = list(map((lambda ngram: " ".join(ngram)), ngrams))
#ngrams_words = [" ".join(ngram) for ngram in ngrams]

uniq_ngrams, counts_ngrams = np.unique(ngrams_words, axis=0, return_counts=True)

ngrams_sorted = sorted(zip(uniq_ngrams, counts_ngrams), key=lambda t: t[1], reverse=True)
print("The 5 most frequenctly ocurring 2-grams are:\n")

for ngs, count in ngrams_sorted[:5]:
    print(ngs,  "-",  count)