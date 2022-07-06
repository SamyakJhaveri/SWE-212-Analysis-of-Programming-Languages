/*Style #5
(Completed on: 11th April 2022)
Constraints:

Larger problem decomposed in procedural abstractions
Larger problem solved as a sequence of commands, each corresponding to a procedure
Possible names:

Cookbook
Procedural
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

// The shared mutable data

var words = make(map[string]int)
var raw_text string
var stopwords []string

// The Procedures

func getText(pnp string) {
	/*
		Get the text of the file passed through command line.
		Store extracted text in 'raw_text'.
	*/
	content, err := os.ReadFile(pnp)
	if err != nil {
		log.Fatal("Cannot open file path", err)
	}
	raw_text = string(content)
}

func get_stopwords() {
	/*
		Read 'stopwords.txt' file to get stopwords.
		Store extracted stopwords in 'stopwords'.
	*/
	sw, err := ioutil.ReadFile("../stop_words.txt")
	if err != nil {
		log.Fatal("Cannot find stopwords", err)
	}
	sw_str := string(sw)
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str = sw_str + "," + string(ch)
	}
	stopwords = strings.Split(sw_str, ",")
}

func checkStopWords(word string, stopwords []string) bool {
	/*
		Helper function to check whether a given string is present in 'stopwords' or not
	*/

	for _, item := range stopwords {
		if item == word {
			return true
		}
	}
	return false
}

func WordCounter() {
	/*
		Generates Regex Engine, converts 'raw_text' to lower case,
		finds all possible matches to each word.
		Calculates the frequency of each word and updated 'words',
		which is a map of word to frequency.
	*/
	reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	text := strings.ToLower(raw_text)
	matches := reg.FindAllString(text, -1)

	for _, match := range matches {

		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}
}

func sorted_frequencies() {
	/*
		Sorts the word frequencies in descending order
		and displays the first 25 most common words in the given text.
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
}

//The Main function

func main() {

	getText(os.Args[1])
	get_stopwords()
	WordCounter()
	sorted_frequencies()
}
