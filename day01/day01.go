package main

import (
	"bufio"
	"strconv"
	"sort"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil { log.Fatal(err) }
	defer file.Close()

	calories := []int {}
	cur_calories := 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if (line != "") {
			calorie, err := strconv.Atoi(line)
			if err != nil { log.Fatal(err) }
			cur_calories += calorie
		} else {
			calories = append(calories, cur_calories)
			cur_calories = 0;
		}
	}

	sort.Slice(calories, func(i, j int) bool {return calories[i] > calories[j]})
	fmt.Println("Part1 result:", calories[0])
	fmt.Println("Part2 result:", calories[0] + calories[1] + calories[2])
}
