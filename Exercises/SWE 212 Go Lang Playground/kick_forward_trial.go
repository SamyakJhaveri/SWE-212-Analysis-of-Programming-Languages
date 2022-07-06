/*Style #9
(Completed on: 18th April 2022)
Constraints:

*/

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"sort"
	"strings"
)

// The Main function
func main() {
	stopwords := get_stopwords()
	getText(WordCounter, stopwords, os.Args[1])
	//print_results(sort_frequencies(WordCounter(get_stopwords(getText(os.Args[1])))))
}

// The Procedures

func getText(f func(func(map[string]int), string, []string), stopwords []string, pnp string) {
	/*
		Takes a path to a file and returns the entire
		contents of the file as a string
	*/
	content, err := os.ReadFile(pnp)
	if err != nil {
		log.Fatal("Cannot open file path", err)
	}
	raw_text := string(content)
	//return raw_text
	WordCounter(sort_frequencies, raw_text, stopwords)
}

func get_stopwords() /*raw_text string WordCounter func(string, []string)*(string, */ []string {
	/*
		Reads 'stop_words.txt' file to get stopwords,
		Adds al the letters of the alphabet to it,
		Returns extracted stopwords in 'stopwords'
		along with 'raw_text' to pass it on to the next function.
	*/

	sw, err := ioutil.ReadFile("../stop_words.txt")
	if err != nil {
		log.Fatal("Cannot find stopwords", err)
	}
	sw_str := string(sw)
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str = sw_str + "," + string(ch)
	}
	stopwords := strings.Split(sw_str, ",")

	return stopwords
	//checkStopWords(raw_text, stopwords)
	//WordCounter(raw_text, stopwords)
}

func WordCounter(f func(map[string]int), raw_text string, stopwords []string) /*, stopwords []string map[string]int*/ {
	/*
		Generates Regex Engine, converts 'raw_text' to lower case,
		finds all possible matches for each word.
		Calculates the frequency of each word and
		returns a map of word-to-frequency.
	*/
	reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	text := strings.ToLower(raw_text)
	/*temp := reg.ReplaceAllString(text, " ")
	word_list := strings.Split(temp, " ")
	fmt.Println("Word List is :")
	fmt.Println(word_list)*/
	matches := reg.FindAllString(text, -1)
	var words = make(map[string]int)

	for _, match := range matches {

		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}
	//return words
	//sort_frequencies(words)
	sort_frequencies(words)

}

func sort_frequencies(words map[string]int) {
	/*
		Sorts the word frequencies in descending order,
		returns 'keys' and 'words'
	*/

	keys := make([]string, 0, len(words))

	for key := range words {
		keys = append(keys, key)
	}

	sort.Slice(keys, func(i, j int) bool {

		return words[keys[i]] > words[keys[j]]
	})

	fmt.Println("Word Frequencies after sorting in reverse:")

	for idx, key := range keys {
		fmt.Printf("%s - %d\n", key, words[key])

		if idx == 24 {
			break
		}
	}
	//print_results(keys, words)
}

/*func print_results(keys []string, words map[string]int) {
	/*
		Prints the 25 most common words from the given text.

	fmt.Println("Word Frequencies after sorting in reverse:")

	for idx, key := range keys {
		fmt.Printf("%s - %d\n", key, words[key])

		if idx == 24 {
			break
		}
	}
}*/
func checkStopWords(word string, stopwords []string) bool {
	/*
		Helper function to check whether a given string
		is present in 'stopwords' or not.
	*/

	for _, item := range stopwords {
		if item == word {
			return true
		}
	}
	return false
}
