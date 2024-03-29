MIDIClient.init;
MIDIIn.connectAll;

~cc_function = {};
~note_on_function = {};
~lpd8_debugging = false;
~debounce_array = [ 0, 0 ];

MIDIdef.cc (\spd_sx_cc) {
	arg ...args;
	var control, value;

	control = args[1];
	value = args[0] / 127;

	if (~lpd8_debugging) {
		args[2] = 9;
	};

	if (args[2] == 9) {
	// if (args[2] == 0) { // for LPD8 debugging
		switch (control)
		{ 1 } {
			Pdefn (\control_1) {
				{ (value ** 1).yield }.loop;
			};
		}
		{ 2 } {
			Pdefn (\control_2) {
				{ (value ** 1).yield }.loop;
			};
		};
		~cc_function.value;
	};

	// "control change!".postln;
	// ("value:   " + args[0]).postln;
	// ("control: " + args[1]).postln;
	// ("channel: " + args[2]).postln;
}.permanent_ (true);

MIDIdef.noteOn (\spd_sx_note_on) {
	arg ...args;
	var note_number, time, velocity;
	if (args[2] == 9) {
		velocity = args[0];
		note_number = args[1];
		time = Date.getDate.rawSeconds;
		~note_on_function.(note_number, time, velocity);
	};

	if (~lpd8_debugging && (args[2] == 10)) {
		note_number = args[1] + 24;
		time = Date.getDate.rawSeconds;
		~note_on_function.(note_number, time, velocity);
	};

	if (note_number == 69) {
		var period;
		period = time - ~debounce_array[0];
		if (period > 0.5) {
			"note on!".postln;
			("velocity: " + args[0]).postln;
			("note:     " + args[1]).postln;
			("channel:  " + args[2]).postln;
		};
		~debounce_array[0] = time;
	};

}.permanent_ (true);