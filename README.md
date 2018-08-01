# REDspace

This is a test project that allows a user to horizontally scroll through three screens that automatically play 
HLS (using AVKit). 

A VideoPlayer encapsulates the playerLayer and the AVPlayer for use in the view controller. The assets are preloaded/fetched 
(asynchronously) to allow for faster playback and various settings were adjusted (ideas taken from WWDC16 and the AVFoundation
docs). 


