(
o = s.options;
// o.device_ ("ZenTour");
// o.device_ ("Built-in Output");
o.device_ ("SPD-SX 44.1kHz");
o.numOutputBusChannels_ (2);
s.options_ (o);
s.boot;
)

"sun_rec_synths.scd".loadRelative;
"sun_rec_midi.scd".loadRelative;
"sun_rec_functions.scd".loadRelative;
"sun_rec_patterns.scd".loadRelative;

~lpd8_debugging = false;

~sub_div = { 4 }; // change here and evaluate

Pbindef (\arp_reggio, \amp, 0.1 ); // volume of the arpeggio

