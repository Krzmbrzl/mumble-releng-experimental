$MUMDIR="c:\dev\mumble\mumble\mumble"
$VCPKGDIR="c:\dev\mumble\mumble\mumble-releng-experimental\vcpkg\"
$triplet="x64-windows-static"
$QTBIN=Join-Path $VCPKGDIR -ChildPath "installed" | Join-Path -ChildPath $triplet | Join-Path -ChildPath "tools\qt5"
$MKSPEC=Join-Path $VCPKGDIR -ChildPath "installed" | Join-Path -ChildPath $triplet | Join-Path -ChildPath "share\qt5\mkspecs\win32-msvc"

echo "Using QTBIN $QTBIN"
echo "For $MUMDIR"
echo "For $triplet"
echo "Qt Makespec $MKSPEC"
echo ""

pushd $MUMDIR

#& $QTBIN\qmake.exe -spec $MKSPEC
#& $QTBIN\qmake.exe -query QMAKE_MKSPECS

#& $QTBIN\qmake.exe

& $QTBIN\qmake.exe `
  -spec $MKSPEC `
  -recursive `
  CONFIG-=sse2 `
  CONFIG+=no-asio `
  CONFIG+=no-g15 `
  CONFIG+=no-bonjour `
  CONFIG+=no-elevation `
  CONFIG+=static `
  CONFIG+=no-update `
  CONFIG+=no-ice

popd
