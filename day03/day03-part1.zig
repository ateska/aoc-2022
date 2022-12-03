const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;


	var total_score: u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const comp1 = line[0..(line.len / 2)];
		const comp2 = line[(line.len / 2)..];

		var shared: u8 = 0;

		// Find shared item
		outer: for (comp1) |item1| {
			for (comp2) |item2| {
				if (item1 == item2) {
					shared = item1;
					//
					break :outer;
				}
			}
		}

		var score: u64 = 0;
		if ((shared >= 'a') and (shared <= 'z')) {
			score += 1 + (shared - 'a');
		} else if ((shared >= 'A') and (shared <= 'Z')) {
			score += 27 + (shared - 'A');
		} else {
			print("Shared item not found '{s}' '{s}' '{s}' '{c}'\n", .{line, comp1, comp2, shared});
			return;
		}

		total_score += score;
	}

	print("Result: {d}\n", .{total_score});
}
