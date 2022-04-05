import re  
import sys
import string


stopwords = set(open('stop_words.txt').read().split(',') + list(string.ascii_lowercase))

all_words = [w.lower() for w in re.split("[^a-zA-Z]+", open(sys.argv[1]).read()) if len(w) > 0 and w.lower() not in stopwords]

unique_words = list(set(all_words))

unique_words.sort(key=lambda x: all_words.count(x), reverse=True)
print("\n".join(["%s - %s" % (x, all_words.count(x)) for x in unique_words[:25]]))