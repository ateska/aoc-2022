const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();
	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();
	var buf: [1024]u8 = undefined;

	var stacks: [9]std.ArrayList(u8) = undefined;
	{
		var i: u64 = 0;
		while (i < stacks.len) : (i += 1) {
			stacks[i] = std.ArrayList(u8).init(std.heap.page_allocator);
		}
	}

	// Inital load
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) break;
		if (line[1] == '1') continue;

		var i: u32 = 0;
		while (i < stacks.len) : (i += 1) {
			const cargo = line[1 + 4*i];
			if (cargo == ' ') continue;
			try stacks[i].insert(0, cargo);
		}
	}

	printStacks(stacks);

	// Moves
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		// Parse line
		var i: u64 = 5;
		var move: u64 = 0;
		while ((line[i] >= '0') and (line[i] <= '9')) {
			move = move * 10 + (line[i] - '0');
			i += 1;
		}
		const mfrom: u64 = line[i+6] - '0';
		const mto: u64 = line[i+11] - '0';

		// Do the move
		var mi: u64 = 0;
		while (mi < move) : (mi += 1) {
			const items = stacks[mfrom-1].items;
			const c = items[(items.len - move) + mi];
			try stacks[mto-1].append(c);
		}

		// Remove cargo from 'from' place
		mi = 0;
		while (mi < move) : (mi += 1) {
			_ = stacks[mfrom-1].pop();
		}
	}

	printStacks(stacks);

	print("Result: ", .{});
	for (stacks) |stack| {
		print("{c}", .{stack.items[stack.items.len-1]});
	}
	print("\n", .{});
}


fn printStacks(stacks: [9]std.ArrayList(u8)) void {
	for (stacks) |stack, i| {
		print("> {d}: ", .{i+1});

		for (stack.items) |item| {
			print("{c} ", .{item});
		}
		print("\n", .{});
	}
	print("\n", .{});
}
