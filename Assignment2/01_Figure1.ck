
// Figure 1 from the paper
// I'm using chuck via the command line by calling `chuck path/to/file`
// I installed chuck with brew

SinOsc foo => dac;

while( true )
{
  Math.random2f( 30, 1000 ) => foo.freq;
  100::ms => now;
}