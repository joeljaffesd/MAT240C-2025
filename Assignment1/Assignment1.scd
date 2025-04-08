// MAT240C 2025 Assignment #1
// Joel A. Jaffe && ChatGPT
// https://chatgpt.com/share/67f5430d-d3e8-8012-b212-9dcdfeef975a

// "The first thing every audio device needs is an off button" - Karl Yerkes
(
~nukeEverything = {
    // Stop all patterns before rebooting the server
	Pdef.all.do(_.stop);
	Tdef.all.do(_.stop);
	thisProcess.stop;  // stops any custom Routines
	s.reboot;  // now it’s safe
};
)

~nukeEverything.(); // <- will use this a lot

// 7 rhythm
(
~rhythm = Pbind(
    \instrument, \default,
    \dur, Pseq([1, 1, 1, 1, 1, 1, 1], inf) * 0.125,
    \freq, 220,
    \amp, Pseq([0.9, 0.5, 0.9, 0.5, 0.9, 0.5, 0.5], inf)
).play;
)

// Blade Runner-style pad synth with more midrange focus
(
SynthDef(\bladepad, {
    |out=0, freq=440, amp=1.0, gate=1|

    // Envelope to ensure smooth fade-in and fade-out for a lush pad sound
    var env = EnvGen.kr(Env.asr(2, 1, 4), gate, doneAction: 2);

    // Detuned oscillators, bringing more harmonic content in the midrange
    var detune = [0, -0.05, 0.05];  // Slight detuning for warmth and depth
    var sig = Mix(VarSaw.ar(freq * (2 ** detune / 12), width: 0.6, mul: 0.4)); // Increased width for a fatter sound

    // Focus the low-pass filter on the midrange frequencies for more warmth
    sig = LPF.ar(sig, XLine.kr(600, 3000, 10));  // Filter focuses on midrange

    // Adding a subtle bit of harmonic distortion or saturation to the signal for richness
    sig = sig + (sig * 0.05);  // Apply some gentle distortion for harmonic content

    // Multiply by the envelope for proper amplitude control
    sig = sig * env * amp;

    // Output stereo signal
    Out.ar(out, sig.dup);
}).add;
)

// Simple test to check the synth's output
Synth(\bladepad, [\freq, 880, \amp, 0.5]);





