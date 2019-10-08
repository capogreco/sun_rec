Pbindef (\arp_reggio).clear;
Pbindef (\arp_reggio,
	// \type, \set,
	\amp, 0.2,
	\delta, 1,

	// \slide_time, Pkey (\delta) * Pfunc { TempoClock.beatDur } / 2,
	// \slide_array, [ 0, 1, 0, 0 ],
	// \slide_on, Pkey (\slide_array).composeBinaryOp (\wrapAt, Pseries ()),

	\len, Pkey (\delta) * TempoClock.beatDur,

	\sustain_array, [ 0.2 ],
	\sustain, Pkey (\sustain_array).composeBinaryOp (\wrapAt, Pseries ()),

	\index_array, [ 2, 1, 0, 1 ],
	\index, Pkey (\index_array).composeBinaryOp (\wrapAt, Pseries ()),

	\freq_array, Pfunc { ~freqs },
	\base_freq, Pfunc {|e| e[\freq_array][e[\index]] },

	\octave_array, [ 0, 0, 0, 0 ],
	\octave, Pkey (\octave_array).composeBinaryOp (\wrapAt, Pseries ()),

	\freq, Pkey (\base_freq) * (2 ** Pkey (\octave)),
);

Pdef (\sine_arp) { Pbind (\instrument, \sine_drop) <> Pbindef (\arp_reggio) };


