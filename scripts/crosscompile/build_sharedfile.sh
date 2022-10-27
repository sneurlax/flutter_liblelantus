#!/bin/bash

. ./config.sh
./prep_sharedfile.sh

echo ''$(git log -1 --pretty=format:"%H")' '$(date) >> build/git_commit_version.txt
if [ ! -f "$VERSIONS_FILE" ]; then
    cp $EXAMPLE_VERSIONS_FILE $VERSIONS_FILE
fi
COMMIT=$(git log -1 --pretty=format:"%H")
sed -i "/\/\*${OS}_VERSION/c\\/\*${OS}_VERSION\*\/ const ${OS}_VERSION = \"$COMMIT\";" $VERSIONS_FILE
cd build
rm CMakeCache.txt
cmake ./mobileliblelantus/ -DCMAKE_TOOLCHAIN_FILE=/home/user/src/flutter_liblelantus/scripts/crosscompile/CMakeLists/Toolchain-cross-mingw32-linux.cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -lws2_32
make -j$(nproc)
make install
