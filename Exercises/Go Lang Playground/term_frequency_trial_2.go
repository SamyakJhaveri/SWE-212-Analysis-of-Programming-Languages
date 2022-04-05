/* https://zetcode.com/golang/word-frequency/
 */

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"regexp"
	"sort"
	"strings"
)

type WordFreq struct {
	word string
	freq int
}

func (p WordFreq) String() string {
	return fmt.Sprintf("%s %d", p.word, p.freq)
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
func checkError(message string, err error) {
	if err != nil {
		log.Fatal(message, err)
	}
}

func main() {

	fileName := "pride-and-prejudice.txt"
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

	reg := regexp.MustCompile("[a-zA-Z']+")
	bs, err := ioutil.ReadFile(fileName)

	if err != nil {
		log.Fatal(err)
	}

	//text := string(bs)
	text := strings.ToLower(string(bs))
	matches := reg.FindAllString(text, -1)

	words := make(map[string]int)

	for _, match := range matches {
		found := checkStopWords(match, stopwords)
		if !found {
			words[match]++
		}
	}

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
