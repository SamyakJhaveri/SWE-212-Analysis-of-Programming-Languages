package main // requiresd at the top of all go files

import "fmt" // probably going to use inall go programs. allows the code to get user input and give result output

func main() { //entry point of program, runs automatically when running go code
	fmt.Println("Hello!")
}

// Go is a compiled language
// That means that our computer cannot diretly execute it. It needs to be converted into a loweer-level executable file
// and then it is executed by the compiler

// How to run:
// go run first_go_trial.go
