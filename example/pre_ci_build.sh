#!/bin/bash

ios_ctm_engine="http://repo.yy.com/dwbuild/mobile/ios/flutterengine/r1.22.1_feature/20201029-150-r799f3cf433d73f08d41b1f4e1afc73f67b193900/ios-release.zip"
#ios_ctm_engine=""
#"83fbe9095a5d3fd6d84da3fdc01e1c01c88134e5-SNAPSHOT"
android_ctm_engine=""

function ios_customize {
  if [[ -n "${ios_ctm_engine}" ]]; then
     # 强行覆盖ios目录
    echo "--- ios_customize download custom engine begin.";

    local engine_zip="$FLUTTER_ROOT/bin/cache/yy_engine.zip"
    echo "--- engine_zip:$engine_zip"
    curl --continue-at - --location --output "$engine_zip" "$ios_ctm_engine" 2>&1 || {
      echo
      echo "Failed to retrieve the Dart SDK from: $DART_SDK_URL"
      echo "If you're located in China, please see this page:"
      echo "  https://flutter.dev/community/china"
      echo
      rm -f -- "$engine_zip"
      exit 1
    }
    echo "--- ios_customize download custom engine end.";

    local unzip_engine_dir="$FLUTTER_ROOT/bin/cache/artifacts/engine"
    echo "--- unzip_engine_dir:$unzip_engine_dir"

    echo "--- ios_customize unzip begin.";
    unzip -o -q "$engine_zip" -d "$unzip_engine_dir" || {
      echo
      echo "It appears that the downloaded file is corrupt; please try again."
      echo "If this problem persists, please report the problem at:"
      echo "  https://github.com/flutter/flutter/issues/new?template=ACTIVATION.md"
      echo
      rm -f -- "$engine_zip"
      exit 1
    }
    echo "--- ios_customize unzip end."
    rm -rf -- "$engine_zip"
  fi
  return 0
}


function android_customize() {
    if [[ -n "${android_ctm_engine}" ]]; then
        echo "android use custom flutter engine: ${android_ctm_engine}"
        echo "$android_ctm_engine" > ${FLUTTER_ROOT}/bin/internal/engine_ctm.version
    else
        echo "android use official flutter engine"
        rm -rf ${FLUTTER_ROOT}/bin/internal/engine_ctm.version
    fi
}

function gradle_repos_replace(){

	repo_url="maven { url 'http:\/\/repo.yypm.com:8181\/nexus\/content\/groups\/public' }"

	for line in $1
	do

		dest_file=`echo ${line} | tr -d '\n\r'`
		jcenter_str=$(cat $dest_file | grep jcenter\(\))
		if [[ -n ${jcenter_str} ]];then
			echo "change $dest_file, remove google/jcenter"
			sed -i "s/google()//" $dest_file
			sed -i "s/jcenter()/${repo_url}/g" $dest_file
		fi
	done
}

function gradle_repos_replace_all(){

	echo "[INFO]RUN :gradle repos replace start"
	# replace pub libs which come from hosted
	[[ -d "$HOME/.pub-cache" ]] || exit 0
	build_gradle_files=`find $HOME/.pub-cache/ -name "build.gradle"`
	gradle_repos_replace "${build_gradle_files}"

	# replace pub libs which is in localplugins
  [[ -d "./localplugins" ]] || exit 0
	build_gradle_files=`find ./localplugins/ -name "build.gradle"`
	gradle_repos_replace "${build_gradle_files}"

	other_gradle_files="
	./.flutter/packages/flutter_tools/gradle/flutter.gradle
	"
  gradle_repos_replace "${other_gradle_files}"

  other_gradle_files="
	./.flutter/packages/flutter_tools/gradle/resolve_dependencies.gradle
	"
  gradle_repos_replace "${other_gradle_files}"

  other_gradle_files2="
	./.android/build.gradle
	"
  gradle_repos_replace "${other_gradle_files2}"

  echo "[INFO]RUN :gradle repos replace end"
}

function init_flutter() {
   echo "[INFO]RUN : flutter packages get"

   export FLUTTER_STORAGE_BASE_URL=https://qamirror.yy.com/flutter

   export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub
   #https://qamirror.yy.com/dart-pub

   # [[ -f ".flutter/version" ]] && use_version=`cat $FLUTTER_DIR_NAME/version`
   # [[ $use_version != $FLUTTER_VERSION ]] && ./flutterw version $FLUTTER_VERSION
   ./flutterw pub get
#   ./flutterw clean
}

function ini_android() {
   echo "[INFO] init android flutter env"
   flutter_version_path="$ROOT_DIR/$FLUTTER_DIR_NAME"
   [[ -d $flutter_version_path ]] || flutter_version_path=$FLUTTER_HOME

#   echo "sdk.dir=$ANDROID_HOME"  > pre_android/local.properties
#   echo "flutter.sdk=$flutter_version_path" >> pre_android/local.properties
   [[ -d "gradle" ]] || cp -r pre_android/gradle gradle
#   [[ -f "gradle.properties" ]] || cp pre_android/gradle.properties gradle.properties

   init_flutter

   android_customize

   ./flutterw precache --android --no-ios

   [[ -n "$BUILD_NUMBER" ]] && gradle_repos_replace_all

   echo "[INFO] init android flutter env end"
}

function ini_ios() {
   echo "[INFO] init ios flutter env start"
   init_flutter
   # 装载自定义engine
   ./flutterw precache --ios --no-android

   ios_customize

   echo "[INFO] init ios flutter env end"
}

ROOT_DIR="`pwd -P`"
FLUTTER_DIR_NAME='.flutter'
FLUTTER_ROOT="$ROOT_DIR/$FLUTTER_DIR_NAME"

if [ -z $1 ];then
   ini_ios
else
   echo "platform $1"
   ini_$1

fi

