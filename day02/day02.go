package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil { log.Fatal(err) }
	defer file.Close()

	total_score_part1 := 0;
	total_score_part2 := 0;

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		// Part 1
		switch (line) {
			case "A X": total_score_part1 += 3 + 1 // We play Rock - draw
			case "A Y": total_score_part1 += 6 + 2 // We play Paper - win
			case "A Z": total_score_part1 += 0 + 3 // We play Scisor - loss
			case "B X": total_score_part1 += 0 + 1 // We play Rock - loss
			case "B Y": total_score_part1 += 3 + 2 // We play Paper - draw
			case "B Z": total_score_part1 += 6 + 3 // We play Scisor - win
			case "C X": total_score_part1 += 6 + 1 // We play Rock - win
			case "C Y": total_score_part1 += 0 + 2 // We play Paper - loss
			case "C Z": total_score_part1 += 3 + 3 // We play Scisor - draw
		}

		// Part 2
		switch (line) {
			case "A X": total_score_part2 += 0 + 3 // We need to lose -> scissors
			case "A Y": total_score_part2 += 3 + 1 // We need to draw -> rock
			case "A Z": total_score_part2 += 6 + 2 // We need to win -> paper
			case "B X": total_score_part2 += 0 + 1 // We need to lose -> rock
			case "B Y": total_score_part2 += 3 + 2 // We need to draw -> paper
			case "B Z": total_score_part2 += 6 + 3 // We need to win -> scissors
			case "C X": total_score_part2 += 0 + 2 // We need to lose -> paper
			case "C Y": total_score_part2 += 3 + 3 // We need to draw -> scissors
			case "C Z": total_score_part2 += 6 + 1 // We need to win -> rock
		}
	}

	fmt.Println("Part1 result:", total_score_part1)
	fmt.Println("Part2 result:", total_score_part2)
}
