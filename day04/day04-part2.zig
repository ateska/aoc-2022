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

		// A of 1st range is in the 2nd range
		//       |A -- 1 --
		// |A -- 2 -- B| 
		if ((r1a.n>=r2a.n) and (r1a.n<=r2b.n)) {
			total_score += 1;
			continue;
		}

		// B of 1st range is in the 2nd range
		//    -- 1 -- B|
		//       |A -- 2 -- B| 
		if ((r1b.n>=r2b.n) and (r1b.n<=r2b.n)) {
			total_score += 1;
			continue;
		}

		// A of 2nd range is in the 1st range
		//  |A -- 1 -- B|
		//        |A -- 2 --
		if ((r2a.n>=r1a.n) and (r2a.n<=r1b.n)) {
			total_score += 1;
			continue;
		}

		// B of 2nd range is in the 1st range
		//       |A -- 1 -- B|
		//    -- 2 -- B|
		if ((r2b.n>=r1a.n) and (r2b.n<=r1b.n)) {
			total_score += 1;
			continue;
		}

	}

	print("Result: {d}\n", .{total_score});
}
