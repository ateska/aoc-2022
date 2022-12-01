const std = @import("std");
const print = @import("std").debug.print;

fn cmpElf(context: void, a: u64, b: u64) bool {
	_ = context;
  return (a > b);
}

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var elf_array = std.ArrayList(u64).init(std.heap.page_allocator);
	defer elf_array.deinit();

	var calorie_sum: u64 = 0;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) | line | {
		if (line.len == 0) {
			try elf_array.append(calorie_sum);
			calorie_sum = 0;
		} else {
			const calorie = try std.fmt.parseUnsigned(u64, line, 10);
			calorie_sum += calorie;	
		}
	}

	var x = elf_array.toOwnedSlice();
	std.sort.sort(u64, x, {}, cmpElf);

	var sum: u64 = 0;
	for (x) | calorie, index | {
		if (index > 2) { break; }
		sum += calorie;
	}

	print("Load of top three elfs: {d}\n", .{sum});
}
