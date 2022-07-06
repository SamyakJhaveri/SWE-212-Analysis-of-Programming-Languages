/* With Reference to: https://github.com/dubirajara/go-word-frequency-counter/blob/main/main.go
https://yourbasic.org/golang/regexp-cheat-sheet/*/
// SUCCESS!
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

//Word type struct defined
type Word struct {
	key   string
	value int
}

func wordCount(str string, stopwords []string) map[string]int {
	wordList := strings.Fields(str)
	wordCounts := make(map[string]int)

	for _, word := range wordList {
		cleanWord := cleanText(strings.ToLower(word))
		found := checkStopWords(cleanWord, stopwords)
		if !found {
			wordCounts[cleanWord]++
		}
	}
	return wordCounts
}

func getText(pnp string) string {
	content, err := os.ReadFile(pnp)
	checkError("Cannot open file path", err)
	raw_text := string(content)
	return raw_text
}

func cleanText(text string) string {
	reg, err := regexp.Compile("[^a-z]+")
	checkError("Cannot clean text", err)

	processedWord := reg.ReplaceAllString(text, "")
	return processedWord
}

func checkStopWords(word string, stopwords []string) bool {

	for _, item := range stopwords {
		if item == word {
			return true
		}
	}

	/*for _, item := range stopwords.StopWords() {
		if item == word {
			return true
		}
	}*/
	return false

}

func sortedWords(words map[string]int) []Word {
	var sorted []Word
	for k, v := range words {
		sorted = append(sorted, Word{k, v})
	}

	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].value > sorted[j].value
	})

	return sorted
}

func checkError(message string, err error) {
	if err != nil {
		log.Fatal(message, err)
	}
}

func print_results(words map[string]int) {
	i := 0
	sorted_Words := sortedWords(words)
	for i = 1; i <= 25; i++ {
		/*word := range sortedWords(words) {
		fmt.Printf("%s -- %d\n", word.key, word.value)*/
		fmt.Printf("%s - %d\n", sorted_Words[i].key, sorted_Words[i].value)
	}

}

func main() {
	sw, err := ioutil.ReadFile("stop_words.txt")
	//sw, err := os.Open("stop_words.txt")

	checkError("Cannot find stopwords", err)

	//fmt.Println("sw:")
	//fmt.Print(sw)

	//scanner := bufio.NewScanner(sw)
	//scanner.Split(bufio.ScanWords)

	sw_str := string(sw)
	//var stopwords []string
	//var stop_words string
	// stopwords := strings.Split(sw_str, ",")

	/*for scanner.Scan() {
		stop_words := scanner.Text()
	}*/

	stopwords := strings.Split(sw_str, ",")

	fmt.Println("stopwords:")
	fmt.Println(stopwords[1])

	content := getText(os.Args[1])
	words := wordCount(content, stopwords)
	print_results(words)
}
