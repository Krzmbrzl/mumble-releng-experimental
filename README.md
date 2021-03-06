﻿# mumble-releng-experimental

WARNING: This is Experimental and is not ready for use yet. Initial development is on-going.

The goal of this project is to prepare a compilation environment for Mumble.

Some dependencies are required for this tool to work.

The Mumble project dependencies (libraries being used) will for the most part be prepared (downloaded and compiled) by this tool.

We intend to provide workflows for setting up partial environments, for example to only compile the Mumble server software without the client, or with specific functionality not included.

`get-mumble_deps.sh` is currently a "proof of concept" designed to deliver vcpkg as a dependency framework for Mumble (client and server) and is likely to change. The long term goal is to automate dependency gathering for the client and server. As written, it should be capable of working on 64 bit Windows, GNU/Linux, and MacOSX. The vcpkg source and its requirements are found [here](https://github.com/Microsoft/vcpkg).

## Roadmap

* [x] Initial script get-mumble_deps.sh
* [ ] Migrate Mumble to CMake ([mumble#3996](https://github.com/mumble-voip/mumble/issues/3996), WIP branch [cmake](https://github.com/davidebeatrici/mumble/tree/cmake))
* [x] Migrate ZeroC Ice project version 3.7 to CMake (upstream integration denied, forked to [mumble-voip/zeroc-ice](https://github.com/mumble-voip/ice), upstream upcoming undecided)

### Preparing Mumble dependencies

#### Windows

So far, this has been tested with MSVC which can be installed from Visual Studio Build Tools, or Visual Studio Community. Either can be downloaded [here](https://visualstudio.microsoft.com/downloads). Make sure to select the C++ build tools (or Development, respectively) and that the "C++ MFC for latest v14[X] build tools" is also checked. vcpkg also requires the English Language pack which is found in the Language packs section of the Visual Studio Installer.

The dependency download and build script requires [Git for Windows](https://git-scm.com/download/win). During installation, make sure the option to set Environment Variables is ticked. It is also suggested to add the Git install directory (i.e. `%ProgramFiles%\Git`) to the User PATH (or System PATH if a multi-user PC) if using cmd or PowerShell to run the script.

Click Start, search for Git Bash and run it. cd to the git repository directory and run the following command:

`./get-mumble_deps.sh`

#### GNU/Linux and MacOSX

Additional `dev` packages will need to be installed for some components in vcpkg on GNU/Linux:

* `libxi(X11)`
* `libgl1-mesa`
* `libglu1-mesa`
* `mesa-common`
* `libxrandr`
* `libxxf86vm`

vcpkg will also require installation of:

* `python3`
* `python2`
* `python`

Most GNU/Linux distros should have these or equivalent packages.

The following is required for MacOSX:

`Xquartz`

vcpkg recommends using `gcc` which can be installed using homebrew.

From a terminal cd to the cloned `mumble-releng-experimental` git repository, set execute permission (`chmod u+x get-mumble_deps.sh`), and run the following command:

`./get-mumble_deps.sh`

This will clone `vcpkg` and install the dependencies in the user's home directory. For Windows builds, if the vcpkg needs to be cloned elsewhere, make sure the path will allow for the maximum character limit for file paths in pre Windows 10 systems.

## Building Mumble

Now that the depdenencies have been prepared with CMake and vcpkg you can build the Mumble project with them.

Mumble (server and client) are built with CMake.

The Mumble project has not been migrated to CMake yet ([ticket #3996](https://github.com/mumble-voip/mumble/issues/3996)).[1] The WIP branch is available at [github.com/davidebeatrici/mumble/tree/cmake](https://github.com/davidebeatrici/mumble/tree/cmake).

### Configure step

It is necessary to download at least version 3.15 of [CMake](https://cmake.org/download/), or install version 3.15 via package manager (yum, apt, etc...) if available, in order to use the Mumble CMake project. For best results in command line builds, create a directory called `build` in the `mumble` repository dir and change to that directory before calling `cmake` for the configure step.

In order for the FindIce module to work properly, `Ice_HOME` must be defined when running the configure step of CMake for the Mumble sources like so:

```
cmake -G <preferred_generator> "-DCMAKE_TOOLCHAIN_FILE=<vcpkg_root>/scripts/buildsystems/vcpkg.cmake" "-DIce_HOME=<vcpkg_root>/installed/x64-windows-static-md" "-DVCPKG_TARGET_TRIPLET=x64-windows-static-md"
```

The other settings `CMAKE_TOOLCHAIN_FILE` and `VCPKG_TARGET_TRIPLET` are necessary to tell the build system where to look for the downloaded dependencies. `<vcpkg_root>` specifies where the repository was installed to.

Additional Mumble project build configuration can be passed with `-D` defines. See the respective CMakeLists.txt files of the projects. For example:

* `-DBUILD_TESTING=[ON | OFF]` - Build tests
* `-DCMAKE_BUILD_TYPE=[Debug | Release]` - Specify the build type multi-config (msbuild, etc...)
* `-Dclient=[ON | OFF]` - Build the client
* `-Dserver=[ON | OFF]` - Build the server
* `-Doverlay=[ON | OFF]` - Build the overlay
* `-Dstatic=[ON | OFF]` - Build as static
* `-Dsymbols=[ON | OFF]` - Build symbols
* `-Dgrpc=[ON | OFF]` - Build with gRPC
* `-Dice=[ON | OFF]` - Build with Ice
* `-Djackaudio=[ON | OFF]` - Build with jack

To configure the project to build the client and server on Windows from the command line you could do the following from a x64 Native Developer Command Prompt:

```
cmake -G "NMake Makefiles" "-DCMAKE_TOOLCHAIN_FILE=<vcpkg_root>/scripts/buildsystems/vcpkg.cmake" "-DIce_HOME=<vcpkg_root>/installed/x64-windows-static-md" "-DVCPKG_TARGET_TRIPLET=x64-windows-static-md" "-Dstatic=ON" "-Dsymbols=ON" "-Djackaudio=OFF" "-Dgrpc=OFF" "-DBUILD_TESTING=OFF"
```

### Build step

Once the project has completed configuration without errors, simply call this command:

```
cmake --build .
```

It is also possible to just call the build tool directly based on the generator that was used. Given the above configure step, you could just call:

```
nmake
```

## Configure and Build using an IDE with CMake support

IDE's such as Qt Creator, Visual Studio and VS Code (Code OSS) are capable of handling the configure and build step as part of the normal operation of the IDE. The options listed above are "Configure Arguments" and would need to be added for the project or workspace settings in the IDE when the source folder is opened as a CMake project.

## Technical Details

We use vcpkg to manage dependencies; to download, compile them and to include them in our own project build.

We use CMake as our build system and to include the dependencies. vcpkg uses and encourages CMake, and CMake is well established in the C++ project space.

### Forks of zeroc-ice and vcpkg for Ice 3.7 CMake

ZeroC Ice 3.7 is not a CMake project. We implemented it as a CMake project so we can integrate it in our CMake project. However, ZeroC does not want to integrate it into upstream 3.7. They are still undecided if they want to use CMake for future versions or a different build system.

As a result we have to [fork the zeroc-ice project](https://github.com/mumble-voip/ice) to integrate our CMake project of it. We also [fork vcpkg](https://github.com/mumble-voip/vcpkg) to integrate this zeroc-ice fork with vcpkg.
