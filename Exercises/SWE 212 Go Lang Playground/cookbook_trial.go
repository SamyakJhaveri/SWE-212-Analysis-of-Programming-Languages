/*Style #5

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

/*type WordFreq struct {
	word string
	freq int
}*/

//var wordFreqs []WordFreq
var words = make(map[string]int)
var raw_text string
var stopwords []string

// The Procedures

/*func (p WordFreq) String() string {
	return fmt.Sprintf("%s - %d", p.word, p.freq)
}*/

func getText(pnp string) {
	content, err := os.ReadFile(pnp)
	if err != nil {
		log.Fatal("Cannot open file path", err)
	}
	raw_text = string(content)
}

func get_stopwords() {
	// Read 'stopwords.txt' file to get stopwords
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

	for _, item := range stopwords {
		if item == word {
			return true
		}
	}
	return false
}
func WordCounter() {
	reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	text := strings.ToLower(raw_text)
	matches := reg.FindAllString(text, -1)

	//words := make(map[string]int)

	for _, match := range matches {

		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}
	//fmt.Println(words)
}

/*func checkError(message string, err error) {
	if err != nil {
		log.Fatal(message, err)
	}
}*/

func sorted_frequencies() {
	//var wordFreqs []WordFreq

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

	/*for k, v := range words {
		wordFreqs = append(wordFreqs, WordFreq{k, v})
	}*/

	/*for i := 0; i < 25; i++ {

		//fmt.Println(wordFreqs[i])
		fmt.Printf("%s - %d", wordFreqs[i].word, wordFreqs[i].freq)
	}*/
}

//The Main function

func main() {

	getText(os.Args[1])
	get_stopwords()
	WordCounter()
	sorted_frequencies()
}
