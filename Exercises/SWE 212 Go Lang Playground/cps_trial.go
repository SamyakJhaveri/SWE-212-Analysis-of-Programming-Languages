// Identity just maps a value passed to the same value

package main

import "fmt"

func identity(v int, wordcount func(int)) {
	wordcount(v + 1)
}
func wordcount(x int) {
	x = x * 2
}

// main.go
func main() {
	identity(5, func(result int) {
		fmt.Println(result) // prints 5
	})
}
