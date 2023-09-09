# Azure RTOS ThreadX For PlatformIO

This is a port of Azure RTOS ThreadX to PlatformIO as a Library. For more information about Azure RTOS, please visit Microsoft Doc and source code on Github.

> 📚 A new [Azure RTOS ThreadX for Arduino 101: Threads](https://www.hackster.io/485734/azure-rtos-threadx-for-arduino-101-threads-963a8d) is avialable on hackster.io.

## Structure

`src/common` and `include/common` is copied directly from ThreadX `common/src` and `common/inc` and is always compiled in.

`src/tx_port.h` and `src/tx_port.S` are added by this project, and use `#if defined()` guards to conditionally compile in the correct port from `ports/`. The ports are not under `src/` so they aren't all automatically compiled by the build system.

## Maintainance

As this is a Warwick Racing fork for internal use, there is no guarantee of regular updates, bugfixes, or support. 

## Updating ThreadX

To update ThreadX, run `python update_threadx.py`

## License

This repository inherit Azure RTOS license from Microsoft. See [LICENSE.txt](./LICENSE.txt) and [LICENSED-HARDWARE.txt](./LICENSED-HARDWARE.txt).
