#!/bin/bash

#set -v

WORK_PATH=$(cd "$(dirname "$0")";pwd)
ANDROID_NDK_PATH=${WORK_PATH}/android-ndk-r23c
OPENSSL_SOURCES_PATH=${WORK_PATH}/openssl-1.1.1s
ANDROID_TARGET_API=$1
ANDROID_TARGET_ABI=$2
OUTPUT_PATH=${WORK_PATH}/openssl_1.1.1s_${ANDROID_TARGET_ABI}

OPENSSL_TMP_FOLDER=/tmp/openssl_${ANDROID_TARGET_ABI}
rm -rf ${OPENSSL_TMP_FOLDER}
mkdir -p ${OPENSSL_TMP_FOLDER}
cp -r ${OPENSSL_SOURCES_PATH}/* ${OPENSSL_TMP_FOLDER}

function build_library {
    rm -rf ${OUTPUT_PATH}
    mkdir -p ${OUTPUT_PATH}
    make && make install
    rm -rf ${OPENSSL_TMP_FOLDER}
    rm -rf ${OUTPUT_PATH}/bin
    rm -rf ${OUTPUT_PATH}/share
    rm -rf ${OUTPUT_PATH}/ssl
    rm -rf ${OUTPUT_PATH}/lib/engines*
    rm -rf ${OUTPUT_PATH}/lib/pkgconfig
    echo "Build completed! Check output libraries in ${OUTPUT_PATH}"
}

if [ "$ANDROID_TARGET_ABI" == "armeabi" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-arm -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

elif [ "$ANDROID_TARGET_ABI" == "armeabi-v7a" ]
then
	#perl -pi -w -e 's/\-mandroid//g;' ./Configure
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-arm -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
     build_library

elif [ "$ANDROID_TARGET_ABI" == "arm64-v8a" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-arm64 -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

elif [ "$ANDROID_TARGET_ABI" == "mips" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-mips -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

elif [ "$ANDROID_TARGET_ABI" == "mips64" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-mips64 -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

elif [ "$ANDROID_TARGET_ABI" == "x86" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-x86 -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

elif [ "$ANDROID_TARGET_ABI" == "x86_64" ]
then
    export ANDROID_NDK_HOME=${ANDROID_NDK_PATH}
    PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    cd ${OPENSSL_TMP_FOLDER}
    ./Configure android-x86_64 -D__ANDROID_API__=${ANDROID_TARGET_API}  shared threads no-asm no-sse2 no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=${OUTPUT_PATH}
    build_library

else
    echo "Unsupported target ABI: $ANDROID_TARGET_ABI"
    exit 1
fi
