/*
Style #4 Monolithic
Constraints:
Constraints:

No abstractions
No/minimal use of library functions

Possible names:

Monolith
Labyrinth
Brain dump
*/

/*
Note about using main() function even in monoliothic style:
Golang does not run without main() funciton so despite
the sample monolithic python code from the course's gthub repo does not use main() funciton,
I have to use it here in the golang implementation. :)
*/

package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"
	"unicode"
)

// Data structure to store pairs of words with
// their corresponding freqeuncies
/* type WordFreq struct {
	word string
	freq int
}*/

func main() {
	// get the stopwords form the file
	// Read 'stop_words.txt' file to get stopwords
	sw, err := ioutil.ReadFile("../stop_words.txt")
	if err != nil {
		log.Fatal("Cannot find stopwords", err)
	}
	sw_str := string(sw)
	//stopwords := strings.Split(sw_str, ",")
	// add single letters of the alphabet to the list of stopwords
	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str += string(ch)
		//stopwords = append(stopwords, string(ch))
		//fmt.Printf("%c   ", ch)
	}

	// get the content of the text file

	// open file
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal("Cannot open file path", err)
	}

	// read the file line by line using scanner
	scanner := bufio.NewScanner(f)
	scanner.Split(bufio.ScanLines)
	// remember to close the file at the end of the program
	defer f.Close()

	word_freqs := make(map[string]int)

	for scanner.Scan() {
		// do something with a line
		//fmt.Printf("line: %s\n", scanner.Text())
		line := scanner.Text()
		start_character := -5 // arbitrarily set to -5
		i := 0

		for i, c := range line {
			if start_character < 0 {
				if unicode.IsLetter(c) {
					// We found the start of the word
					start_character = i
				}
			} else {
				if unicode.IsLetter(c) == false {
					// We found the end of the word. Process it.
					found := false
					word := strings.ToLower(line[start_character:i])
					// Ignore stopwords

					if strings.Contains(sw_str, word) == false {
						pair_index := 0
						// Now lets see if it already exists
						for k := range word_freqs {
							if word == k {
								word_freqs[k] += 1
								found = true
								break
							}
							pair_index += 1
						}

						if found == false {
							word_freqs[word] = 1
						}
					}
					start_character = -5

				}
			}
			i += 1
		}
		_ = i
	}

	fmt.Print("Word Frequencies before sorting in reverse:")
	fmt.Println(word_freqs)
	fmt.Println("---------------")

	keys := make([]string, 0, len(word_freqs))
	for key := range word_freqs {
		keys = append(keys, key)
	}
	/*var sorted []Word
	for k, v := range words {
		sorted = append(sorted, Word{k, v})
	} */

	sort.Slice(keys, func(i, j int) bool {
		return word_freqs[keys[i]] > word_freqs[keys[j]]
	})

	fmt.Println("Word Frequencies after sorting in reverse:")

	for idx, key := range keys {
		fmt.Printf("%s - %d\n", key, word_freqs[key])

		if idx == 24 {
			break
		}
	}
}
