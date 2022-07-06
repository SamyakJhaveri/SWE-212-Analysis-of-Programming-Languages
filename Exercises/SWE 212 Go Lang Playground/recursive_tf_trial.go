/*Style #6
(Completed on: 11th April 2022)
Constraints:

Larger problem decomposed in functional abstractions. Functions, according to Mathematics, are relations from inputs to outputs.
Larger problem solved as a pipeline of function applications
Possible names:

Candy factory
Functional
Pipeline
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

// The Procedures

func getText(pnp string) string {
	/*
		Takes a path to a file and returns the entire
		contents of the file as a string
	*/
	content, err := os.ReadFile(pnp)
	if err != nil {
		log.Fatal("Cannot open file path", err)
	}
	raw_text := string(content)
	return raw_text
}

func get_stopwords(raw_text string) (string, []string) {
	/*
		Reads 'stop_words.txt' file to get stopwords,
		Adds al the letters of the alphabet to it,
		Returns extracted stopwords in 'stopwords'
		along with 'raw_text' to pass it on to the next function.
	*/
	sw, err := ioutil.ReadFile("../../stop_words.txt")
	if err != nil {
		log.Fatal("Cannot find stopwords", err)
	}
	sw_str := string(sw)
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str = sw_str + "," + string(ch)
	}
	stopwords := strings.Split(sw_str, ",")
	return raw_text, stopwords
}

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

func WordCounter(raw_text string, stopwords []string) map[string]int {
	/*
		Generates Regex Engine, converts 'raw_text' to lower case,
		finds all possible matches for each word.
		Calculates the frequency of each word and
		returns a map of word-to-frequency.
	*/
	reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	text := strings.ToLower(raw_text)
	matches := reg.FindAllString(text, -1)
	var words = make(map[string]int)

	for _, match := range matches {

		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}
	return words
}

func sort_frequencies(words map[string]int) ([]string, map[string]int) {
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
	return keys, words
}

func print_results(keys []string, words map[string]int) {
	/*
		Prints the 25 most common words from the given text.
	*/
	fmt.Println("Word Frequencies after sorting in reverse:")

	for idx, key := range keys {
		fmt.Printf("%s - %d\n", key, words[key])

		if idx == 24 {
			break
		}
	}
}

// The Main function

func main() {

	print_results(sort_frequencies(WordCounter(get_stopwords(getText(os.Args[1])))))
}
