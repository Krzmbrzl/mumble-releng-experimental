$triplet="x64-windows-static"

$VCPKGDIR="vcpkg"

pushd $VCPKGDIR

echo "Installing dependencies for $triplet..."

./vcpkg install `
  --triplet $triplet `
  asio `
  bzip2 `
  boost-accumulators `
  boost-array `
  boost-atomic `
  boost-bind `
  boost-function `
  boost-optional `
  boost-signals `
  boost-smart-ptr `
  boost-typeof `
  expat `
  freetype `
  gRPC `
  libflac `
  libjpeg-turbo `
  libogg `
  libpng `
  libsndfile `
  libvorbis `
  openssl `
  opus `
  pcre `
  protobuf `
  qt5-base `

#  qt5-imageformats qt5-modularscripts qt5-multimedia qt5-networkauth qt5-speech qt5-svg qt5-tools

# missing
# berkleydb
# bonjour
# cmake
# g15sdk
# harfbuzz-ng # harfbuff exists, is it the same as ng?
# jom
#libmcpp
# libopus # same as opus??
#mariadb-client # libmariadb??
#nasm
#perl
#python
#qt5

popd
