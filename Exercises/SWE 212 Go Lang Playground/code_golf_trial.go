/*
Style #7
(Completed On: 11th April 2022)
Constraints:

As few lines of code as possible
Possible names:

Code golf
Try hard
*/
package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"sort"
	"strings"
)

/*func checkStopWords(word string, stopwords []string) bool {
	for _, item := range stopwords {
		if item == word {
			return true
		}
	}
	return false
}*/

func main() {
	content, err := os.ReadFile(os.Args[1])
	raw_text := string(content)
	sw, err := ioutil.ReadFile("../stop_words.txt")
	_ = err
	sw_str := string(sw)
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str = sw_str + "," + string(ch)
	}
	//reg := regexp.MustCompile("\\w+") //[a-zA-Z']+
	matches := (regexp.MustCompile("\\w+")).FindAllString((strings.ToLower(raw_text)), -1)
	var words = make(map[string]int)
	for _, match := range matches {
		if !(strings.Contains(sw_str, match)) {
			words[match]++
		}
	}
	keys := make([]string, 0, len(words))
	for key := range words {
		keys = append(keys, key)
	}
	sort.Slice(keys, func(i, j int) bool {
		return words[keys[i]] > words[keys[j]]
	})
	for idx, key := range keys {
		fmt.Printf("%s - %d\n", key, words[key])
		if idx == 24 {
			break
		}
	}
}
