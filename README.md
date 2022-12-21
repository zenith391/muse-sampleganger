# muse-sampleganger
 Replacement library for MuseSampler

## Installation

### On Linux

You need Zig 0.10.0 or later

```sh
# Build the code
zig build
# Save the previous muse sampler library
sudo mv /usr/lib/libMuseSamplerCoreLib.so /usr/lib/libMuseSamplerCoreLib_original.so
sudo ln -s $(pwd)/zig-out/lib/libmuse-sampleganger.so /usr/lib/libMuseSamplerCoreLib.so
```
Launch MuseScore and profit!

To revert the changes, just execute:
```sh
sudo rm /usr/lib/libMuseSamplerCoreLib.so
sudo mv /usr/lib/libMuseSamplerCoreLib_original.so /usr/lib/libMuseSamplerCoreLib.so
```