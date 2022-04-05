// Go Lang version of term frequency calculator
/* Steps:
1. Get Pride and Prejudice file from folder
2. Get stopwords text file form folder
3. Extract all the words in the text file in lower case
4. remove the stopwords from the words extracted
5. print out the 25 most common words
6. make the file such athat adheres to the requirements
specified by the assignemnt on Canvas
*/

/* Reference:
- https://gosamples.dev/read-file/
*/

package main

import (
	"fmt"
	"log"
	"os"

	"github.com/sugarme/tokenizer/pretrained"
)

func main() {
	content, err := os.ReadFile("pride-and-prejudice.txt")
	if err != nil { // error checking
		log.Fatal(err)
	}

	tk := pretrained.BertBaseUncased()

	// Creating a Buffer Scanner. Scanner is typically used to read a file line-by-line
	//scanner := bufio.NewScanner(file)

	// Reading each line in the text and printing it out

	raw_text := string(content)
	en, err := tk.EncodeSingle(raw_text)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("tokens: %q\n", en.Tokens)
	fmt.Printf("offsets: %v\n", en.Offsets)
	/*all_words := strings.Split(raw_text, " ")
	fmt.Println(all_words)*/
}
