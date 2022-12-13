import copy

def locate_in_grid(grid, what):
	for y in range(len(grid)):
		for x in range(len(grid[0])):
			if grid[y][x] == what:
				return x, y


def locate_all_in_grid(grid, what):
	for y in range(len(grid)):
		for x in range(len(grid[0])):
			if grid[y][x] == what:
				yield x, y


def main():
	grid = []
	matrix_orig = []
	with open('input.txt') as fi:
		for line in fi.readlines():
			oline = []
			mline = []
			for c in line.strip():
				oline.append(ord(c))
				mline.append(999)
			grid.append(oline)
			matrix_orig.append(mline)

	ex, ey = locate_in_grid(grid, ord('E'))
	sx, sy = locate_in_grid(grid, ord('S'))
	grid[sy][sx] = ord('a')
	starts = list(locate_all_in_grid(grid, ord('a')))

	results = []

	for sx, sy in starts:

		matrix = copy.deepcopy(matrix_orig)
		matrix[sy][sx] = 0

		grid[ey][ex] = ord('z')

		changed = True
		while changed:
			changed = False
			for y in range(len(grid)):
				for x in range(len(grid[0])):
					if matrix[y][x] == 999:
						continue

					step = matrix[y][x]
					es = grid[y][x]  # Elevation of the source

					# Can we move up?
					if y > 0 and grid[y - 1][x] <= (es + 1):
						if matrix[y - 1][x] > (step + 1):
							matrix[y - 1][x] = step + 1
							changed = True

					# Can we move down?
					if y < (len(grid) - 1) and grid[y + 1][x] <= (es + 1):
						if matrix[y + 1][x] > (step + 1):
							matrix[y + 1][x] = step + 1
							changed = True

					# Can we move left
					if x > 0 and grid[y][x - 1] <= (es + 1):
						if matrix[y][x - 1] > (step + 1):
							matrix[y][x - 1] = step + 1
							changed = True

					# Can we move down?
					if x < (len(grid[0]) - 1) and grid[y][x + 1] <= (es + 1):
						if matrix[y][x + 1] > (step + 1):
							matrix[y][x + 1] = step + 1
							changed = True

		results.append(matrix[ey][ex])
		print("Progress: {}/{}".format(len(results), len(starts)))

	print("Result:", sorted(results)[0])


if __name__ == '__main__':
	main()
