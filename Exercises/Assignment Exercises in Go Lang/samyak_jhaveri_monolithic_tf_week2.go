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

func main() {
	// get the stopwords form the file
	// Read 'stop_words.txt' file to get stopwords
	sw, err := ioutil.ReadFile("../stop_words.txt")
	if err != nil {
		log.Fatal("Cannot find stopwords", err)
	}
	sw_str := string(sw)

	for ch := 'a'; ch <= 'z'; ch++ {
		sw_str += string(ch)
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

						// Now lets see if it already exists
						for k := range word_freqs {
							if word == k {
								word_freqs[k] += 1
								found = true
								break
							}
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

	// sorting the word_freqs in reverse order of frequency
	keys := make([]string, 0, len(word_freqs))
	for key := range word_freqs {
		keys = append(keys, key)
	}
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
