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

type WordFreq struct {
	word string
	freq int
}

func (p WordFreq) String() string {
	return fmt.Sprintf("%s - %d", p.word, p.freq)
}

func checkStopWords(word string, stopwords []string) bool {

	for _, item := range stopwords {
		if item == word {
			return true
		}
	}
	return false

}

func checkError(message string, err error) {
	if err != nil {
		log.Fatal(message, err)
	}
}

func getText(pnp string) string {
	content, err := os.ReadFile(pnp)
	checkError("Cannot open file path", err)
	raw_text := string(content)
	return raw_text
}

func WordCounter(content string, stopwords []string) map[string]int {
	reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	text := strings.ToLower(content)
	matches := reg.FindAllString(text, -1)

	words := make(map[string]int)

	for _, match := range matches {
		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}
	return words
}

func main() {

	content := getText(os.Args[1])

	// Read 'stopwords.txt' file to get stopwords
	sw, err := ioutil.ReadFile("../../stop_words.txt")
	checkError("Cannot find stopwords", err)
	sw_str := string(sw)
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str = sw_str + "," + string(ch)
	}
	stopwords := strings.Split(sw_str, ",")

	words := WordCounter(content, stopwords)

	var wordFreqs []WordFreq
	for k, v := range words {
		wordFreqs = append(wordFreqs, WordFreq{k, v})
	}

	sort.Slice(wordFreqs, func(i, j int) bool {

		return wordFreqs[i].freq > wordFreqs[j].freq
	})

	for i := 0; i < 25; i++ {

		fmt.Println(wordFreqs[i])
	}
}
