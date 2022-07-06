import sys, re, operator, string
sys.setrecursionlimit(1000)


'''global frequency_list
global keys_list
frequency_list = []
keys_list = []'''

def getText(path_to_file):
    '''
    Takes path to the file and converts the 
    content into string.
    '''

    with open(path_to_file) as f:
        content = f.read()
    
    f.close()

    # Normalize the 'content' by converting it inot 
    # lowercase and replacing all the punctuations into ' '

    regexEngine = re.compile('[\W_]+')
    
    return regexEngine.sub(' ', content).lower()

def getStopwords():
    stopwords_file_path = '../../stop_words.txt'
    with open(stopwords_file_path) as sw:
        stopwords = sw.read().split(',')
    
    sw.close()
    stopwords.extend(list(string.ascii_lowercase))
    return stopwords

def remove_stopwords(raw_text, stopwords):
    word_list_cleaned = []
    word_list = raw_text.split()
    for word in word_list:
        if word not in stopwords:
            word_list_cleaned.append(word)
    
    return word_list_cleaned

def WordCounter(word_list_cleaned):
    word_freqs = {}

    for word in word_list_cleaned:
        if word in word_freqs:
            word_freqs[word] += 1
        else:
            word_freqs[word] = 1

    return word_freqs

def order_dict(dictionary):
    return {k: order_dict(v) if isinstance(v, dict) else v
            for k, v in sorted(dictionary.items())}

'''def partition(low, high):
    global frequency_list
    global keys_list
    i = (low - 1)            
    pivot = frequency_list[high]
 
    for j in range(low, high):
        # If current element is smaller than or
        # equal to pivot
        if frequency_list[j] > pivot:
            i += 1
            #i += 1
            frequency_list[i], frequency_list[j] = frequency_list[j], frequency_list[i]
            #keys_list[j], keys_list[i] = keys_list[i], keys_list[j]

    frequency_list[i+1], frequency_list[high] = frequency_list[high], frequency_list[i+1]
    keys_list[i+1], keys_list[high] = keys_list[high], keys_list[i+1]
    frequency_list[i+1], frequency_list[high] = frequency_list[high], frequency_list[i + 1]
    #keys_list[pivot], keys_list[i-1] = keys_list[i-1], keys_list[pivot]


    return (i+1)

def quickSort(low, high):
    if len(frequency_list) <= 1:
        return frequency_list
    if low < high:
        pi = partition(low, high)

        quickSort(low, pi - 1)
        quickSort(pi + 1, high)'''

def main():
    '''global frequency_list
    global keys_list'''
    
    raw_text = getText(sys.argv[1])
    stopwords = getStopwords()

    word_list_cleaned = remove_stopwords(raw_text, stopwords)

    word_freqs = WordCounter(word_list_cleaned)

    frequency_list = list(word_freqs.values())
    keys_list = list(word_freqs.keys())
    '''n = len(frequency_list)
    quickSort(0, n - 1)'''
    results = order_dict(word_freqs)

    print("Sorted array is:")
    print(results) 
    


if __name__ == "__main__":
    main()