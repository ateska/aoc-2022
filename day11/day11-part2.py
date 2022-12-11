import re


class Item(object):

	def __init__(self, worry_level):
		self.WorryLevel = int(worry_level)

	def mul(self, argument):
		self.WorryLevel *= argument

	def plus(self, argument):
		self.WorryLevel += argument

	def power2(self):
		self.WorryLevel = self.WorryLevel * self.WorryLevel

	def relief(self):
		self.WorryLevel = self.WorryLevel % (2 * 3 * 5 * 7 * 11 * 13 * 17 * 19)


class Monkey(object):

	def __init__(self, monid, items, operation, argument, testdiv, iftrue, iffalse):
		self.MonkeyId = monid
		self.Items = items
		if argument == 'old' and operation == '*':
			self.Operation = '^'
			self.Argument = None
		else:
			self.Operation = operation
			self.Argument = int(argument)
		self.TestDiv = testdiv
		self.IfTrue = iftrue
		self.IfFalse = iffalse
		self.Counter = 0

	def round(self):
		item = self.Items.pop(0)

		if self.Operation == '*': 
			item.mul(self.Argument)
		elif self.Operation == '+': 
			item.plus(self.Argument)
		elif self.Operation == '^': 
			item.power2()
		else:
			raise RuntimeError("Unknown operation '{}'".format(self.Operation))

		self.Counter += 1

		item.relief()

		if (item.WorryLevel % self.TestDiv) == 0:
			return (self.IfTrue, item)
		else:
			return (self.IfFalse, item)


def main():
	with open("input.txt", "r") as fi:
		instructions = fi.read()

	rg = re.compile(
		r"""Monkey ([0-9]+):\s+Starting items:((\s[0-9]+,)*(\s[0-9]+))\s+Operation: new = old (.)\s([0-9]+|old)\s+Test: divisible by ([0-9]+)\s+ If true: throw to monkey ([0-9]+)\s+ If false: throw to monkey ([0-9]+)""",
		flags=re.MULTILINE
	)	

	monkeys = {}
	for instruction in rg.findall(instructions):
		monkey = Monkey(
			monid=int(instruction[0]),
			items=[Item(x) for x in instruction[1].strip().split(', ')],
			operation=instruction[4],
			argument=instruction[5],
			testdiv=int(instruction[6]),
			iftrue=int(instruction[7]),
			iffalse=int(instruction[8]),
		)
		monkeys[monkey.MonkeyId] = monkey

	for round in range(10000):
		for monkey in monkeys.values():
			while len(monkey.Items) > 0:
				monkey_id, worry_level = monkey.round()
				monkeys[monkey_id].Items.append(worry_level)

	most_active = sorted(monkeys.values(), key=lambda monkey: monkey.Counter)
	sorted_counters = [monkey.Counter for monkey in most_active]
	print("Part2: ", sorted_counters[-2] * sorted_counters[-1])


if __name__ == '__main__':
	main()
