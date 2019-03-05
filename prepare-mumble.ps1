$TARGET="mumble"
$REPO="https://github.com/mumble-voip/mumble.git"

if(!(Test-Path -Path $TARGET )){
  echo "Cloning $$REPO into $TARGET..."
  git clone $REPO $VCPKGDIR
} else {
  pushd $TARGET
  git pull
  popd
}

pushd $TARGET

git submodule update --init

popd
