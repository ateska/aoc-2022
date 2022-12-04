const std = @import("std");
const print = @import("std").debug.print;

pub fn readInt(line: []u8, until: u8, pos: u64) struct { n: u64, pos: u64} {
	var n: u64 = 0;
	var i: u64 = pos;
	while (i < line.len) {
		const c: u8 = line[i];
		if (c == until) {
			i += 1;
			break;
		}
		n = n * 10 + (c - '0');
		i += 1;
	}
	return .{.n = n, .pos = i};
}

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var total_score: u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {

		const r1a = readInt(line, '-', 0);
		const r1b = readInt(line, ',', r1a.pos);
		const r2a = readInt(line, '-', r1b.pos);
		const r2b = readInt(line, '\n', r2a.pos);

		// 1st range is completelly bellow the second ranga
		if (r1b.n < r2a.n) {
			continue;
		}

		// 1st range is completelly above the second ranga
		if (r1a.n > r2b.n) {
			continue;
		}

		// Everything else is the overlap
		total_score += 1;
	}

	print("Result: {d}\n", .{total_score});
}
