import sys, re, operator, string
sys.setrecursionlimit(10000)
# RECURSION_LIMIT = 100
# sys.setrecursionlimit(RECURSION_LIMIT+10)

global frequency_list
global keys_list
frequency_list = []
keys_list = []

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
    stopwords_file_path = '/Users/poojabhatia/Documents/APL_VSCODE/stop_words.txt'
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

def partition(low, high):
    global frequency_list
    global keys_list
    pivot = frequency_list[high]
    i = low - 1
    for j in range(low, high):
        if frequency_list[j] > pivot:
            i = i + 1
            (frequency_list[i], frequency_list[j]) = (frequency_list[j], frequency_list[i])
            # (keys_list[i], keys_list[j]) = (keys_list[j], keys_list[i])

    (frequency_list[i + 1], frequency_list[high]) = (frequency_list[high], frequency_list[i + 1])
    # (keys_list[i + 1], keys_list[high]) = (keys_list[high], keys_list[i + 1])

    return i + 1

# Function to perform quicksort
def quick_sort(low, high):
    if low < high:
        pi = partition(low, high)
        quick_sort(low, pi - 1)
        quick_sort(pi + 1, high)


def main():
    global frequency_list
    global keys_list
    raw_text = getText('/Users/poojabhatia/Documents/APL_VSCODE/pride-and-prejudice.txt')
    stopwords = getStopwords()

    word_list_cleaned = remove_stopwords(raw_text, stopwords)

    word_freqs = WordCounter(word_list_cleaned)
    frequency_list = list(word_freqs.values())
    keys_list = list(word_freqs.keys())
    # n = len(frequency_list)
    # step = 500
    # for a in range(0, n, step):
    #     quickSort(frequency_list[a : a + step], keys_list[a : a + step], 0, n - 1)
    quick_sort(0, len(frequency_list)-1)

    print("Sorted array is:")
    for i in range(25):
        print("{} - {}".format(keys_list[i], frequency_list[i]))    
  

if __name__ == "__main__":
    main()