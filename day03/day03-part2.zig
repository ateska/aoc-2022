const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var threelines: [3][1024]u8 = undefined;
	var threelineslen: [3]usize = undefined;

	var line_counter: u64 = 0;

	var total_score: u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {

		for (line) |char, i| {
			threelines[line_counter % 3][i] = char;
		}
		threelineslen[line_counter % 3] = line.len;

		line_counter += 1;
		if (line_counter == 3) {
			line_counter = 0;

			// Find shared item
			var shared: u8 = 0;
			outer: for (threelines[0][0..threelineslen[0]]) |item1| {
				if (std.mem.indexOfScalar(u8, threelines[1][0..threelineslen[1]], item1) != null) {
					if (std.mem.indexOfScalar(u8, threelines[2][0..threelineslen[2]], item1) != null) {
						shared = item1;
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
				print("Cannot find shared item\n", .{});
				return;
			}

			total_score += score;

		}
	}

	print("Result: {d}\n", .{total_score});
}
