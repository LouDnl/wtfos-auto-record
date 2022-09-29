# WTFOS - Autostart Recording

## NOTES
- This is a work in progress
- This is an install only package, no configuration is needed for now
- This project is distributed under MIT license

### CHANGELOG
- Open the [changelog](CHANGELOG.md) to see the most recent changes

##### Install
- `opkg install auto-record`

##### Manual install
- `make ipk`
- `adb push auto-record_1.0.0_pigeon-glasses.ipk /tmp`
- open up shell with `adb shell`
- `opkg install /tmp/auto-record_1.0.0_pigeon-glasses.ipk`
- or `opkg upgrade /tmp/auto-record_1.0.0_pigeon-glasses.ipk` if the version is newer

##### Known issues
- Recording stops on disarm, normal DJI behaviour.

##### TODO
- [x] Write header file
- [x] Write source code
- [x] Update README.me
- [ ] Start auto-record on AU when full-size AU
- [ ] Add config options for auto-record
- [ ] Disable recording stop on disarm or restart recording immediately until loss of signal

##### Credits
- Inspired by funnels solution
- https://github.com/funneld/djifpv_auto_start_recording
