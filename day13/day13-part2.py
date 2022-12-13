from functools import cmp_to_key


def reccomp(l1, l2):

	for x1, x2 in zip(l1, l2):

		# Both are list
		if isinstance(x1, list) and isinstance(x2, list):
			ret = reccomp(x1, x2)
			if ret is None:
				continue
			else:
				return ret

		# Mixed
		elif isinstance(x1, list) and not isinstance(x2, list):
			ret = reccomp(x1, [x2])
			if ret is None:
				continue
			else:
				return ret

		elif not isinstance(x1, list) and isinstance(x2, list):
			ret = reccomp([x1], x2)
			if ret is None:
				continue
			else:
				return ret

		if x1 == x2:
			continue
		elif x1 < x2:
			return True
		else:
			return False

	# Left side ran out of items, so inputs are in the right order
	if len(l1) < len(l2):
		return True
	elif len(l1) > len(l2):
		return False
	else:
		return None


def reccomp1(l1, l2):
	r = reccomp(l1, l2)
	print("reccomp1", l1, l2, r)
	return r


class Packet(object):

	def __init__(self, packet):
		self.Packet = packet

	def __lt__(self, other):
		return reccomp(self.Packet, other.Packet)


def main():

	inputs = [
		Packet([[6]]),
		Packet([[2]]),
	]

	with open("input.txt") as fi:
		while True:
			l1 = fi.readline()
			if l1 == '':
				break
			if l1 == '\n':
				continue
			l1 = eval(l1)

			inputs.append(Packet(l1))

	inputs = sorted(inputs)

	result = 1
	for i, packet in enumerate(inputs, 1):
		if packet.Packet == [[6]]:
			result *= i
		elif packet.Packet == [[2]]:
			result *= i


	print("Result:", result)


if __name__ == '__main__':
	main()
