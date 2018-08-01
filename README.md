# REDspace

This is a test project that allows a user to horizontally scroll through three views that automatically play 
HLS (using AVKit). 

A VideoPlayer encapsulates the playerLayer and the AVPlayer for use in the view controller. The assets are preloaded/fetched 
(asynchronously) to allow for faster playback and various settings were adjusted (ideas taken from WWDC16 and the AVFoundation
docs). 

The VideoLoader class is responsible for connecting to the three URLs and fetching the asset values. It uses a DispatchGroup to make sure that the assets are all loaded before setting up the scroll view. I also had to make sure that the array of assets was thread safe. 
