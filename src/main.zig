const std = @import("std");
const apitypes = @import("apitypes.zig");
const backend = @import("backend.zig");

const allocator = std.heap.c_allocator;

var instrument_list: InstrumentList = undefined;

comptime {
    _ = MuseSampler;
}

const instruments = &[_]InstrumentInfo {
    .{ .id = 0, .name = "Square Wave", .category = "Muse Hijacks", .package = "Muse Hijacks", .musicxml_sound_id = "square_wave", .mpe_sound_id = "square_wave" },
};

pub const InstrumentList = struct {
    index: usize = 0,

    pub export fn ms_InstrumentList_get_next(self: *InstrumentList) ?*const InstrumentInfo {
        std.log.info("ms_InstrumentList_get_next()", .{});
        if (self.index >= instruments.len) {
            return null;
        } else {
            defer self.index += 1;
            return &instruments[self.index];
        }
    }
};

pub const InstrumentInfo = struct {
    /// Some unique ID for the instrument
    id: c_int,
    name: [:0]const u8,
    category: [:0]const u8,
    package: [:0]const u8,
    musicxml_sound_id: [:0]const u8,
    mpe_sound_id: [:0]const u8,

    pub export fn ms_Instrument_get_id(self: *InstrumentInfo) c_int {
        return self.id;
    }

    pub export fn ms_Instrument_get_name(self: *InstrumentInfo) [*:0]const u8 {
        return self.name;
    }

    pub export fn ms_Instrument_get_category(self: *InstrumentInfo) [*:0]const u8 {
        return self.category;
    }

    pub export fn ms_Instrument_get_package(self: *InstrumentInfo) [*:0]const u8 {
        return self.package;
    }

    pub export fn ms_Instrument_get_musicxml_sound(self: *InstrumentInfo) [*:0]const u8 {
        return self.musicxml_sound_id;
    }

    pub export fn ms_Instrument_get_mpe_sound(self: *InstrumentInfo) [*:0]const u8 {
        return self.mpe_sound_id;
    }

    pub export fn ms_Instrument_get_preset_list(self: *InstrumentInfo) *PresetList {
        _ = self;
        return undefined;
    }
};

pub const PresetList = struct {
    a: usize = 0,

    pub export fn ms_PresetList_get_next(self: *PresetList) ?[*:0]const u8 {
        _ = self;
        //return "Lol no";
        return null;
    }
};

pub export fn ms_init() void {
    std.log.info("Initializing our döppelganger MuseSampler library!", .{});
}

pub export fn ms_get_version_major() c_int {
    return 0;
}

pub export fn ms_get_version_minor() c_int {
    return 3;
}

pub export fn ms_get_version_revision() c_int {
    return 2;
}

pub export fn ms_get_version_string() [*:0]const u8 {
    return "HA HA HA YOU'RE HIJACKED";
}

pub export fn ms_contains_instrument(mpe_id: [*:0]const u8, musicxml_id: [*:0]const u8) c_int {
    std.log.info("Do we have instrument {s} / {s}", .{ mpe_id, musicxml_id });
    return 0;
}

pub export fn ms_get_matching_instrument_id(pack: [*:0]const u8, name: [*:0]const u8) c_int {
    std.log.info("ms_get_matching_instrument_id(\"{s}\", \"{s}\")", .{ pack, name });
    return 0;
}

pub export fn ms_get_instrument_list() *InstrumentList {
    instrument_list = .{};
    return &instrument_list;
}

pub export fn ms_get_matching_instrument_list(mpe_id: [*:0]const u8, musicxml_id: [*:0]const u8) *InstrumentList {
    _ = mpe_id;
    _ = musicxml_id;
    return undefined;
}

pub const MuseSampler = struct {
    sample_rate: f64 = 44100,
    block_size: c_int = 512,
    channel_count: c_int = 1,
    notes: std.ArrayList(Note),
    auditionNotes: std.ArrayList(Note),
    dynamics: std.ArrayList(Dynamic),
    playing: bool = false,

    pub const Note = struct {
        /// The time it start, in seconds
        location: f64,
        /// The time it lasts, in seconds
        duration: f64,
        /// MIDI pitch.
        pitch: c_int,
        /// The frequency to be played
        frequency: u16,
    };

    pub const Dynamic = struct {
        /// The time it start, in seconds
        location: f64,
        /// From 0 to 1, the volume of the dynamic
        value: f32,
    };

    pub export fn ms_MuseSampler_create() ?*MuseSampler {
        std.log.info("ms_MuseSampler_create()", .{});
        const ptr = allocator.create(MuseSampler) catch return null;
        ptr.* = .{
            .notes = std.ArrayList(Note).init(allocator),
            .auditionNotes = std.ArrayList(Note).init(allocator),
            .dynamics = std.ArrayList(Dynamic).init(allocator)
        };
        return ptr;
    }

    pub export fn ms_MuseSampler_init(self: *MuseSampler, sample_rate: f64, block_size: c_int, channel_count: c_int) apitypes.ms_Result {
        std.log.info("ms_MuseSampler_init({d}, {d}, {d})", .{sample_rate, block_size, channel_count});
        self.sample_rate = sample_rate;
        self.block_size = block_size;
        self.channel_count = channel_count;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_set_demo_score(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_clear_score(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_finalize_score(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_add_track(self: *MuseSampler, instrument_id: c_int) *Track {
        // TODO
        _ = self;
        _ = instrument_id;
        return undefined;
    }

    pub export fn ms_MuseSampler_finalize_track(self: *MuseSampler, track: *Track) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_clear_track(self: *MuseSampler, track: *Track) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_add_track_note_event(self: *MuseSampler, track: *Track, event: apitypes.ms_NoteEvent) apitypes.ms_Result {
        _ = track;
        std.log.info("ms_MuseSampler_add_track_note_event({})", .{ event });
        self.notes.append(.{
            .location = @intToFloat(f64, event._location_us) / std.time.us_per_s,
            .duration = @intToFloat(f64, event._duration_us) / std.time.us_per_s,
            .pitch = event._pitch,
            .frequency = midiPitchToFrequency(event._pitch),
        }) catch return apitypes.ms_Result_Error;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_add_track_dynamics_event(self: *MuseSampler, track: *Track, event: apitypes.ms_DynamicsEvent) apitypes.ms_Result {
        _ = track;
        std.log.info("ms_MuseSampler_add_track_dynamics_event({})", .{ event });
        self.dynamics.append(.{
            .location = @intToFloat(f64, event._location_us) / std.time.us_per_s,
            .value = @floatCast(f32, event._value),
        }) catch return apitypes.ms_Result_Error;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_add_track_pedal_event(self: *MuseSampler, track: *Track, event: apitypes.ms_PedalEvent) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        std.log.info("ms_MuseSampler_add_track_pedal_event({})", .{ event });
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_is_ranged_articulation(articulation: apitypes.ms_NoteArticulation) c_int {
        // TODO
        _ = articulation;
        return 0;
    }

    pub export fn ms_MuseSampler_add_track_event_range_start(self: *MuseSampler, track: *Track, voice: c_int, articulation: apitypes.ms_NoteArticulation) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        _ = voice;
        _ = articulation;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_add_track_event_range_end(self: *MuseSampler, track: *Track, voice: c_int, articulation: apitypes.ms_NoteArticulation) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        _ = voice;
        _ = articulation;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_start_audition_note(self: *MuseSampler, track: *Track, event: apitypes.ms_AuditionStartNoteEvent) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        std.log.info("ms_MuseSampler_start_audition_note({})", .{ event });
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_stop_audition_note(self: *MuseSampler, track: *Track, event: apitypes.ms_AuditionStopNoteEvent) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        std.log.info("ms_MuseSampler_stop_audition_note({})", .{ event });
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_start_liveplay_mode(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_stop_liveplay_mode(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_start_liveplay_note(self: *MuseSampler, track: *Track, event: apitypes.ms_LivePlayStartNoteEvent) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        _ = event;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_stop_liveplay_note(self: *MuseSampler, track: *Track, event: apitypes.ms_LivePlayStopNoteEvent) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = track;
        _ = event;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_start_offline_mode(self: *MuseSampler, sample_rate: f64) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = sample_rate;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_stop_offline_mode(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_process_offline(self: *MuseSampler, output: apitypes.ms_OutputBuffer) apitypes.ms_Result {
        // TODO
        _ = self;
        _ = output;
        return apitypes.ms_Result_OK;
    }

    /// samples is the number of samples since the start of the music
    pub export fn ms_MuseSampler_process(self: *MuseSampler, output: apitypes.ms_OutputBuffer, samples: c_longlong) apitypes.ms_Result {
        const sample_count = output._num_data_pts;
        var time = @intToFloat(f64, samples) / self.sample_rate;

        var i: usize = 0;
        while (i < sample_count) : (i += 1) {
            var sample: f32 = 0;
            if (self.playing) {
                // TODO: stereo
                var playing_notes = std.BoundedArray(Note, 32).init(0) catch unreachable;
                for (self.notes.items) |note| {
                    if (time >= note.location and time < note.location + note.duration) {
                        playing_notes.append(note) catch {};
                    }
                }

                var dynamic_value: f32 = 0;
                for (self.dynamics.items) |dynamic| {
                    if (time >= dynamic.location) {
                        dynamic_value = dynamic.value;
                    }
                }

                backend.process(&sample, time, playing_notes.constSlice(), dynamic_value);
            }

            var audition_sample: f32 = 0;
            backend.process(&audition_sample, time, self.auditionNotes.items, 0.5);
            sample += audition_sample;
            
            time += 1 / self.sample_rate;

            output._channels[0][i] = sample;
            output._channels[1][i] = sample;
        }
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_set_position(self: *MuseSampler, samples: c_longlong) void {
        // TODO
        _ = self;
        _ = samples;
    }

    pub export fn ms_MuseSampler_set_playing(self: *MuseSampler, playing: c_int) void {
        self.playing = playing != 0;
    }

    pub export fn ms_MuseSampler_all_notes_off(self: *MuseSampler) apitypes.ms_Result {
        // TODO
        _ = self;
        return apitypes.ms_Result_OK;
    }

    pub export fn ms_MuseSampler_destroy(self: *MuseSampler) void {
        self.notes.deinit();
        self.auditionNotes.deinit();
        self.dynamics.deinit();
        allocator.destroy(self);
    }
};

pub const Track = struct {
    a: usize = 0,
};

pub fn midiPitchToFrequency(pitch: c_int) u16 {
    // The frequency of A4
    const tuning: f32 = 440.0;

    return @floatToInt(u16, 
        (tuning / 32) * std.math.pow(f32, 2, (@intToFloat(f32, pitch - 9) / 12.0)));
}
