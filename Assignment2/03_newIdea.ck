// An attempt at how I might write audio effect classes in ChucK

// This is a simple one-pole low-pass filter applied to some white noise

//==========================================

class OnePole 
{
  float x_0;
  float y_1;
  float a1;
  
  fun void init() 
  {
    0.0 => x_0;
    0.0 => y_1;
    0.0 => a1;
  }
  
  fun void setCutoff(float hz, float sampleRate) 
  {
    2.0 * Math.PI * hz / sampleRate => float omega;
    Math.exp(-omega) => a1;
  }
  
  fun float processSample(float input) 
  {
    input => x_0;
    (1.0 - a1) * x_0 + a1 * y_1 => y_1;
    return y_1;
  }
}

// Noise source
Noise n => Gain g => dac;

// Create and initialize the filter
OnePole f;
f.init();
f.setCutoff(10, 44100); // Set cutoff frequency to 1000 Hz

// Process audio in a loop
while( true )
{
  // Get a sample from the noise source
  float sample;
  n.last() => sample;
  
  // Process the sample through the filter
  f.processSample(sample) => g.gain;
  
  // Advance time by one sample
  1::samp => now;
}