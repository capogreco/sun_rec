~output_bus = 0;

SynthDef (\kick) {
	arg len = 0.3, pan = 0, amp = 0.2, freq = 55, click = 0.4, lithe = 1, squeal = 0;
	var sig, env_amp, env_freq, stack;

	env_amp  = Env.perc (0.01, len - 0.01, 0.2, -16 * lithe);
	env_amp  = EnvGen.kr (env_amp, doneAction: 2);

	env_freq = Env.perc (0, 0.02, 1);
	env_freq = EnvGen.ar (env_freq);

	click = 22050 * click;
	click = click ** env_freq;

	stack = Array.fill (16);
	sig = 0;

	16.do {
		arg i;
		sig = SinOsc.ar ((freq + click) * ((3 / 2) ** (16 - i)), sig * pi, env_amp);
		stack[i] = SinOsc.ar ((freq + click), sig * pi, env_amp);
	};

	sig = SelectX.ar (15 - (squeal * 15), stack);

	sig = SoftClipAmp.ar (sig, 16);
	sig = Pan2.ar (sig, pan, amp);

	Out.ar (0, sig);
}.add;

SynthDef (\snare) {
	arg len = 0.6, pan = 0, amp = 0.2, freq = 55, snap = 1, spread = 0, supple = 1, squonk = 0;
	var sig, amp_env, stack, tube_squonk;

	amp_env = Env.perc (0.01, len - 0.01, amp, -16 * supple);
	amp_env = EnvGen.kr (amp_env, doneAction: 2);

	sig = 0;
	stack = Array.fill (16);

	16.do {
		arg i;
		sig = SinOsc.ar (freq * ((spread + 1) ** (16 - i)), sig * pi);
		stack[i] = SinOsc.ar (freq, sig * pi);
	};

	sig = SelectX.ar (snap * 15, stack);
	tube_squonk = (SampleRate.ir / freq) ** (1 - squonk);

	// sig = SoftClipAmp8.ar (sig, 16);
	sig = TwoTube.ar (sig, 0.01, 1, tube_squonk * 3 / 2, tube_squonk);
	sig = SoftClipAmp8.ar (sig, 16);
	sig = Pan2.ar (sig, pan, amp_env);
	Out.ar (0, sig);
}.add;

SynthDef (\bell) {
	arg freq = 880, pan = 0, amp = 0.2, len = 0.6, spread = 1, thickness = 1.0;
	var sig, amp_env, stack, stack_number;

	amp_env = Env.perc (0.01, len - 0.01, amp);
	amp_env = EnvGen.kr (amp_env, doneAction: 2);

	sig = 1;

	stack = Array.fill (7);

	7.do {
		arg i;
		sig = sig * SinOsc.ar (freq * (1.5 ** i), Rand (-pi, pi));
		stack[i] = sig;
	};

	sig = SelectX.ar ((thickness * 6) + 1, stack);
	// sig = stack[0];
	sig = Pan2.ar (sig, pan, amp_env);

	Out.ar (0, sig);
}.add;

SynthDef (\sine) {
	arg freq = 110, amp = 0.1, slide_time = 0, pan = 0, vibrato_width = 0, vibrato_rate = 0, slide_on = 0;
	var sig;
	freq = Select.kr (slide_on, [ freq, Lag.kr (freq, slide_time) ]);
	freq = freq * SinOsc.ar (freq * (0.0078125 ** (1 - vibrato_rate)), Rand (2pi), vibrato_width, 1);
	sig = SinOsc.ar (freq);
	sig = Pan2.ar (sig, pan, amp);
	Out.ar (0, sig);
}.add;

SynthDef (\sine_drop) {
	arg freq = 110, len = 1, sustain = 0.2, amp = 0.1, pan = 0;
	var sig, env;
	env = Env ([ 0, 1, 0 ], [ 0, len ], (sustain * 16) - 8 );
	env = EnvGen.kr (env, doneAction: 2);
	sig = SinOsc.ar (freq);
	sig = Pan2.ar (sig, pan, amp * env);
	Out.ar (0, sig);
}.add;

// SynthDef (\tri_min_7) {
// 	arg freq = 330, amp = 0.2, slide_time = 0.2, pan = 0, detune = 0;
// 	var sig;
// 	freq = Lag.kr (freq, slide_time);
// 	freq = freq * [ 1, 3, 6, 9 ] / [ 1, 2, 5, 5 ];
// 	detune = Array.fill (4) {LFNoise2.kr (Rand (1.0, 2.0), detune)};
// 	freq = freq * (2 ** (detune / 12));
// 	sig = LFTri.ar (freq);
// 	sig = Splay.ar (sig) * amp;
// 	// sig = Pan2.ar (sig, pan, amp);
// 	Out.ar (0, sig);
// }.add;

// SynthDef (\saw_block) {
// 	arg freq = 330, amp = 0.2, pan = 0,
// 	holo_harm = 0, detune = 0, slide_time = 0.2;
//
// 	var env, freq_env, sine, saw, sig, harm_number;
//
// 	holo_harm = Lag.kr (holo_harm, 0.05);
// 	freq = Lag.kr (freq, slide_time);
//
// 	harm_number = 64;
// 	sig = [ 0, 0 ];
// 	harm_number.do {
// 		arg i;
// 		var amp, detune_sig, pan_sig;
// 		amp = (1 / (i + 1)) * Clip.kr (((holo_harm * (harm_number - 1)) + 1) - i, 0, 1);
// 		detune_sig = SinOsc.ar (freq * (i + 1) / 4096, Rand (0.0, 2 * pi), detune, 1) ** (i / harm_number);
// 		pan_sig = SinOsc.ar (freq * (i + 1) / 4096, Rand (0.0, 2 * pi), detune) * (i / harm_number);
// 		detune_sig = SinOsc.ar (freq * (i + 1) * detune_sig, 0, amp);
// 		detune_sig = Pan2.ar (detune_sig, pan_sig);
// 		sig = sig + detune_sig;
// 	};
// 	sig = sig * amp;
// 	Out.ar (0, sig);
// }.add;