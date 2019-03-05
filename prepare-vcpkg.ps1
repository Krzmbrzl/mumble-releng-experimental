
$VCPKGDIR="vcpkg"

if(!(Test-Path -Path $VCPKGDIR )){
  echo "Cloning vcpkg into $VCPKGDIR…"
  git clone https://github.com/Microsoft/vcpkg.git $VCPKGDIR
}

pushd $VCPKGDIR

.\bootstrap-vcpkg.bat

popd
