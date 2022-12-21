const MuseSampler = @import("main.zig").MuseSampler;
const Note = MuseSampler.Note;

// Here we implement a square wave
pub inline fn process(output: *f32, time: f64, playing_notes: []const Note, dynamic: f32) void {
	var sample: f32 = 0;
	
	for (playing_notes) |note| {
		const period: f32 = 1.0 / @intToFloat(f32, note.frequency);
		const value: f32 = if (@rem(time, period) < period / 2) -1.0 else 1.0;
		const volume: f32 = 0.05;
		sample += value * volume * dynamic;
	}

	output.* = sample;
}
