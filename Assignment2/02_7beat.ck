// MAT240C 2025 Assignment #2
// Joel A. Jaffe && ChatGPT

// Generated from this convo:
// https://chatgpt.com/share/68002b56-398c-8012-8315-e1af7b34372c
// Used copilot to correct two errors.

// If further assignments keep translating this example to 
// more audio languages, this could be a case study in generation loss

//============================================================================

// "The first thing every audio device needs is an off button" - Karl Yerkes

// --- nukeEverything ---
// Kill all running shreds (including itself at the end)
fun void nukeEverything() {
    Machine.removeAllShreds();
}

// Run this to stop everything
// nukeEverything(); // <- Uncomment when needed

// --- rhythm ---
fun void rhythm() {
    SinOsc s => Gain g => dac;
    0.5 => g.gain;

    [0.9, 0.5, 0.9, 0.5, 0.9, 0.5, 0.5] @=> float amps[];
    0.125::second => dur beat;

    while (true) {
        for (0 => int i; i < amps.cap(); i++) {
            220 => s.freq;
            amps[i] => g.gain;
            beat => now;
        }
    }
}
spork ~ rhythm();

// --- bladepad synth ---
fun void bladepad(float freq, float amp) {
    // 3 detuned VarSaws (using SawOsc as an approximation)
    SawOsc s1 => LPF f => Gain g => dac;
    SawOsc s2 => f;
    SawOsc s3 => f;
    
    // Envelope (Attack, Sustain, Release)
    Envelope env => g;
    2::second => dur attack;
    4::second => dur release;
    
    // Set frequencies
    freq => s1.freq;
    freq * Math.pow(2, -0.05/12.0) => s2.freq;
    freq * Math.pow(2, 0.05/12.0) => s3.freq;

    // Set LPF filter to sweep from 600Hz to 3000Hz over 10 seconds
    600 => f.freq;
    spork ~ sweepFilter(f);

    // Set amplitudes (each voice is slightly softer)
    0.13 => s1.gain;
    0.13 => s2.gain;
    0.13 => s3.gain;

    // Gentle distortion - additive soft gain
    // ChucK doesn’t do saturation directly; we'll simulate by soft-clipping with an offset
    g => dac;

    // Envelope shape
    env.keyOn();
    amp => g.gain;
    attack => now;

    // Hold sustain
    3::second => now;

    // Release
    env.keyOff();
    release => now;
    
    // Done
    g =< dac;
}

// Filter sweep helper
fun void sweepFilter(LPF f) {
    600 => float startFreq;
    3000 => float endFreq;
    10::second => dur sweepTime;
    now => time start;
    while (now - start < sweepTime) {
        // Convert dur to float (in seconds) for division
        (now - start) / 1::second => float elapsedSeconds;
        sweepTime / 1::second => float totalSeconds;
        elapsedSeconds / totalSeconds => float progress;
        (startFreq + (endFreq - startFreq) * progress) => f.freq;
        10::ms => now;
    }
}

// --- test the synth ---
while (true) {
    bladepad(880, 0.5);
}
