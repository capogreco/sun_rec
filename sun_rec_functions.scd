~freqs = [ 330, 660, 990 ];
~last_time = Date.getDate.rawSeconds!4;

~cc_function = {
	TempoClock.tempo_ (0.5  + (16 ** Pdefn (\control_1).asStream.next)).postln;
	~rejig_func.(21 * Pdefn (\control_2).asStream.next + 3);

	// "~cc_function was called.".postln;
	// ("cc 1: " ++ Pdefn (\control_1).asStream.next.asString).postln;
	// ("cc 2: " ++ Pdefn (\control_2).asStream.next.asString).postln;
};

~patch_on = false;

~start_func = {
	"start func called".postln;
	if (~patch_on.not) {
		a = Pdef (\sine_arp).play;
		~patch_on = true;
	};
};

~fin_func = {
	if (~patch_on) {
		a.stop;
		~patch_on = false;
	};
};


~rejig_func = {
	arg array_length = 7;
	var new_index_array, new_octave_array, new_slide_array;
	array_length = array_length.asInt;
	new_index_array = Array.fill (array_length) { 3.rand };
	new_octave_array = Array.fill (array_length) { (-1..1).choose };
	new_slide_array = Array.euclid (array_length, array_length.rand, array_length.rand);
	new_octave_array.postln;
	Pbindef (\arp_reggio,
		\index_array, new_index_array,
		\octave_array, new_octave_array,
		\slide_array,new_slide_array,
	);
};

~change_pitch = {
	arg synth_number, time;
	var period, frequency;
	synth_number.postln;
	time.postln;
	period = time - ~last_time[synth_number];
	frequency = period.reciprocal * 128;
	if (frequency > 20) {
		~freqs[synth_number] = frequency;
	};
	~last_time[synth_number] = time;
};

~bass_note = {
	arg ind;
	Synth (\kick, [
		\amp, 0.4,
		\freq, ~freqs[ind] * (2 ** (ind + 1).neg),
		\len, TempoClock.tempo.reciprocal * 16 * (2 ** ind),
	]);
};

~bell_note = {
	arg ind;
	Synth (\bell, [
		\amp, 0.3,
		\freq, ~freqs[ind],
		\len, TempoClock.tempo.reciprocal * 2,
		\thickness, 0,
	]);
};

~sub_div = { 4 };

~tap_tempo = {
	arg time;
	var period, sub;
	period = time - ~last_time[3];
	sub = period / ~sub_div.value;
	if (period < 2) {
		TempoClock.tempo_ (sub.reciprocal);
		Pdefn (\control_1) {
			{ sub.yield }.loop;
		};
	};
	~last_time[3] = time;
};

~note_on_function = {
	arg note_number, time;

	switch (note_number)
	{ 60 }  {
		~start_func.value;
	}
	{ 61 }  {
		if (~patch_on.not) {
			~tap_tempo.(time);
		} {
			~bell_note.(1);
		};
	}
	{ 62 } {
		~fin_func.value;
	}
	{ 63 } {
		~change_pitch.(0, time);
	}
	{ 64 } {
		~change_pitch.(1, time);
	}
	{ 65 } {
		~change_pitch.(2, time);
	}
	{ 66 }{
		~bass_note.(0);
	}
	{ 67 }{
		~bass_note.(1);
	}
	{ 68 }{
		~bass_note.(2);
	};
	// "~note_on_function was called.".postln;
	// ("with note number " ++ note_number.asString).postln;
	// ("at " ++ time.asString ++ "s").postln;
};


