
def reccomp(l1, l2, indent=0):
	print("{}- Compare {} vs {}".format(' ' * indent, l1, l2))

	for x1, x2 in zip(l1, l2):

		# Both are list
		if isinstance(x1, list) and isinstance(x2, list):
			ret = reccomp(x1, x2, indent+1)
			if ret is None:
				continue
			else:
				return ret

		# Mixed
		elif isinstance(x1, list) and not isinstance(x2, list):
			ret = reccomp(x1, [x2], indent + 1)
			if ret is None:
				continue
			else:
				return ret

		elif not isinstance(x1, list) and isinstance(x2, list):
			ret = reccomp([x1], x2, indent + 1)
			if ret is None:
				continue
			else:
				return ret

		print("{}  - Compare {} vs {}".format(' ' * indent, x1, x2))

		if x1 == x2:
			continue
		elif x1 < x2:
			print("   - Left side is smaller, so inputs are in the right order")
			return True
		else:
			print("   - Right side is smaller, so inputs are not in the right order")
			return False

	# Left side ran out of items, so inputs are in the right order
	if len(l1) < len(l2):
		print("Left side ran out of items, so inputs are in the right order")
		return True
	elif len(l1) > len(l2):
		print("Right side ran out of items, so inputs are not in the right order")
		return False
	else:
		return None


def main():

	inputs = []
	with open("input.txt") as fi:
		while True:
			l1 = fi.readline()
			if l1 == '':
				break
			l1 = eval(l1)
			l2 = eval(fi.readline())
			e = fi.readline().strip()
			assert len(e) == 0

			inputs.append((l1, l2))

	suminp = []
	for n, (l1, l2) in enumerate(inputs, 1):
		print("\n== Pair {} ==".format(n))
		ret = reccomp(l1, l2)
		if ret:
			print("IS")
			suminp.append(n)
		else:
			print("NOT")


	# 6695 ... too high
	print("Result:", suminp, sum(suminp))


if __name__ == '__main__':
	main()
