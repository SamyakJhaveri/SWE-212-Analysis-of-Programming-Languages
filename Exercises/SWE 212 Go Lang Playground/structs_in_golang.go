package main

import "fmt"

type person struct {
	name string
	age  int
}

func newPerson(name string) *person {
	p := person{name: name}
	p.age = 42
	return &p
}

func main() {
	fmt.Println(person{"Bobs", 20})

	fmt.Println(person{name: "Vagene", age: 30})

	fmt.Println(person{name: "Tits"})

	fmt.Println(&person{name: "Ass", age: 25})

	fmt.Println(newPerson("Pussy"))

	s := person{name: "Clit", age: 20}
	fmt.Println(s.name)

	sp := &s
	fmt.Println(sp.age)

	sp.age = 19
	fmt.Println(sp.age)

}
