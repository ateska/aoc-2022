const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var best_elf: u64 = 0;
	var best_elf_sum: u64 = 0;
	var current_elf: u64 = 1;
	var current_elf_sum: u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			print("Elf: {d} {d}\n", .{current_elf, current_elf_sum});

			if (current_elf_sum > best_elf_sum) {
				best_elf = current_elf;
				best_elf_sum = current_elf_sum;
			}
			current_elf += 1;
			current_elf_sum = 0;
		} else {
			const load = try std.fmt.parseUnsigned(u64, line, 10);
			current_elf_sum += load;
			
		}
	}

	print("Result: {d} {d}\n", .{best_elf, best_elf_sum});

}
