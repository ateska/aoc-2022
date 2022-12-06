const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buffer: [8*1024]u8 = undefined;
	const inplen = try file.read(buffer[0..buffer.len]);
	const data = buffer[0..inplen];

	var pos:u64 = 0;
	outer: while (pos+4 < inplen) {
		var marker: []u8 = data[pos..pos+4];
		for (marker[0..marker.len-1]) |a, i| {
			for (marker[i+1..marker.len]) |b| {
				if (a == b) {
					pos += 1;
					continue :outer;
				}
			}
		}
		print(">> {s} {d}\n", .{marker, pos +  marker.len});
		break;
	}
}
