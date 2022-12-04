const std = @import("std");
const print = @import("std").debug.print;

const Range = struct {
	n: u64,
	pos: u64,

	pub fn init(n: u64, pos: u64) Range {
        return Range {
            .n = n,
            .pos = pos,
        };
    }
};

pub fn readInt(line: []u8, what: u8, pos: u64) Range  {
	var n: u64 = 0;
	var i: u64 = pos;
	while (i < line.len) {
		const c: u8 = line[i];
		if (c == what) {
			i += 1;
			break;
		}
		n = n * 10 + (c-'0');
		i += 1;
	}
	return Range.init(n, i);
}

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var total_score: u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {

		const r1 = readInt(line, '-', 0);
		const r2 = readInt(line, ',', r1.pos);
		const r3 = readInt(line, '-', r2.pos);
		const r4 = readInt(line, 'x', r3.pos);

		if ((r1.n<=r3.n) and (r2.n>=r4.n)) {
			total_score += 1;
		} else if ((r3.n<=r1.n) and (r4.n>=r2.n)) {
			total_score += 1;
		}

	}

	print("Result: {d}\n", .{total_score});
}
