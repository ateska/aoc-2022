import re
import sys

fsizerg = re.compile(r"^([0-9]+) .*$")

def process_dir(dirname, lines, result):
	lsinst = lines.pop(0)
	assert lsinst == '$ ls\n'

	dirsize = 0
	while len(lines) > 0:
		instr = lines.pop(0)
		
		# Found directory to go into
		if instr.startswith('dir '):
			continue

		if instr.startswith('$ cd '):
			if instr[5:-1] == '..':
				result.append(dirsize)
				return dirsize
			else:
				dirsize += process_dir(instr[5:-1], lines, result)
				continue

		# Found a file size
		fm = fsizerg.match(instr)
		if fm is not None:
			fsize = int(fm.group(1))
			dirsize += fsize
			continue

		print("???", instr)
		sys.exit(-1)

	return dirsize

def main():
	with open("input.txt") as f:
		lines = f.readlines()

	cdinst = lines.pop(0)
	assert cdinst == '$ cd /\n'

	dirsizes = []
	dirsize = process_dir('/', lines, dirsizes)

	y = 0
	for x in dirsizes:
		if x <= 100000:
			y += x
	print("Part 1:", y)

	dirsizes = sorted(dirsizes)
	need = 30000000 - (70000000 - dirsize)
	print("Needed:", need)
	for x in dirsizes:
		print(x, need, x - need)
		if x > need:
			print("Part 2:", x)
			break

if __name__ == '__main__':
	main()
