#!/bin/bash
set -e

if [[ "${IS_IGNORE_ERRORS}" == "true" ]] ; then
echo " (i) Ignore Errors: enabled"
set +e
else
echo " (i) Ignore Errors: disabled"
fi

echo
echo '#'
echo '# This System Report was generated by: https://github.com/bitrise-io/osx-box-bootstrap/blob/master/system_report.sh'
echo '#  Pull Requests are welcome!'
echo '#'
echo

echo
echo "=== Revision / ID ======================"
echo "* BITRISE_OSX_STACK_REV_ID: $BITRISE_OSX_STACK_REV_ID"
echo "========================================"
echo

# Make sure that the reported version is only
#  a single line!
echo
echo "=== Pre-installed tool versions ========"

ver_line="$(go version)" ;                        echo "* Go: $ver_line"
ver_line="$(ruby --version)" ;                    echo "* Ruby: $ver_line"
ver_line="$(python --version 2>&1 >/dev/null)" ;  echo "* Python: $ver_line"
ver_line="$(node --version)" ;                    echo "* Node.js: $ver_line"
ver_line="$(npm --version)" ;                     echo "* NPM: $ver_line"
ver_line="$(java -version 2>&1 >/dev/null)" ;     echo "* Java: $ver_line"


echo
ver_line="$(git --version)" ;                     echo "* git: $ver_line"
ver_line="$(git lfs version)" ;                   echo "* git lfs: $ver_line"
ver_line="$(hg --version | grep version)" ;       echo "* mercurial/hg: $ver_line"
ver_line="$(curl --version | grep curl)" ;        echo "* curl: $ver_line"
ver_line="$(wget --version | grep 'GNU Wget')" ;  echo "* wget: $ver_line"
ver_line="$(rsync --version | grep version)" ;    echo "* rsync: $ver_line"
ver_line="$(unzip -v | head -n 1)" ;              echo "* unzip: $ver_line"
ver_line="$(zip -v | head -n 2 | tail -n 1)";     echo "* zip: $ver_line"
ver_line="$(tar --version | head -n 1)" ;         echo "* tar: $ver_line"
ver_line="$(tree --version)" ;                    echo "* tree: $ver_line"

echo
ver_line="$(brew --version)" ;                    echo "* brew: $ver_line"

# xctool was removed, not installed on new Stacks
set +e
ver_line="$(xctool --version)" ;                  echo "* xctool: $ver_line"
if [[ "${IS_IGNORE_ERRORS}" != "true" ]] ; then
set -e
fi

ver_line="$(ansible --version | grep ansible)" ;  echo "* Ansible: $ver_line"
ver_line="$(gtimeout --version | grep 'timeout')" ;  echo "* gtimeout: $ver_line"
ver_line="$(watchman --version)" ;                echo "* watchman: $ver_line"
ver_line="$(flow version)" ;                      echo "* flow: $ver_line"
ver_line="$(carthage version)" ;                  echo "* carthage: $ver_line"
ver_line="$(convert --version | head -1)" ;       echo "* imagemagick (convert): $ver_line"
ver_line="$(ps2ascii --version)" ;                echo "* ghostscript (ps2ascii): $ver_line"

# wine was removed, not installed on new Stacks
set +e
ver_line="$(wine --version)" ;                    echo "* wine: $ver_line"
if [[ "${IS_IGNORE_ERRORS}" != "true" ]] ; then
set -e
fi

echo
echo "--- Bitrise CLI tool versions"
ver_line="$(bitrise --version)" ;                 echo "* bitrise: $ver_line"
ver_line="$(/Users/vagrant/.bitrise/tools/stepman --version)" ; echo "* stepman: $ver_line"
ver_line="$(/Users/vagrant/.bitrise/tools/envman --version)" ;  echo "* envman: $ver_line"
ver_line="$(bitrise-bridge --version)" ;          echo "* bitrise-bridge: $ver_line"
ver_line="$(cmd-bridge --version)" ;              echo "* cmd-bridge: $ver_line"
echo "========================================"
echo

echo
echo "=== Ruby GEMs =========================="
ver_line="$(bundle --version)" ;                  echo "* Bundler: $ver_line"
ver_line="$(pod --version)" ;                     echo "* CocoaPods: $ver_line"
ver_line="$(fastlane --version)" ;                echo "* fastlane: $ver_line"
ver_line="$(xcpretty --version)" ;                echo "* xcpretty: $ver_line"
ver_line="$(gem -v nomad-cli)" ;                  echo "* Nomad CLI: $ver_line"
ver_line="$(ipa --version)" ;                     echo "* Nomad CLI IPA / Shenzhen: $ver_line"
echo "========================================"
echo

echo
echo "=== All Ruby GEMs ======================"
gem list
echo "========================================"
echo

echo
echo "=== Checking Xcode CLT dirs ============"
# installed by `xcode-select --install`, if called *before*
#  Xcode.app is installed
echo
echo " * ls -alh /usr/include/CommonCrypto"
ls -alh /usr/include/CommonCrypto
echo
echo " * ls -alh /Library/Developer/CommandLineTools/"
ls -alh /Library/Developer/CommandLineTools/
echo
echo " * /Library/Developer/CommandLineTools/usr/bin/swift --version"
/Library/Developer/CommandLineTools/usr/bin/swift --version
echo
echo "========================================"
echo

echo
echo "=== Xcode =============================="
echo
echo "* Active Xcode Command Line Tools:"
xcode-select --print-path
echo
echo "* Xcode Version:"
xcodebuild -version
echo
echo "* Installed SDKs:"
xcodebuild -showsdks
echo
echo "* Available Simulators:"
xcrun simctl list | grep -i --invert-match 'unavailable'
echo
echo "========================================"
echo

echo
echo "=== OS X info ========================="
echo
echo "* sw_vers"
sw_vers
echo
echo "* system_profiler SPSoftwareDataType"
system_profiler SPSoftwareDataType
echo
echo "========================================"
echo

echo
echo "=== System infos ======================="
info_line="$( df -kh / | grep '/' )" ;            echo "* Free disk space: $info_line"
echo "========================================"
echo

if [ ! -z "$BITRISE_XAMARIN_FOLDER_PATH" ] ; then
  echo
  echo "=== Xamarin specific ==================="
  echo
  echo "--- Xamarin"
  echo
  echo "* Xamarin Studio"
  cat "/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/buildinfo"
  echo
  echo "* Mono version:"
  mono --version
  echo "* Mono path:"
  which mono
  echo
  echo "* Xamarin.Android"
  cat /Developer/MonoAndroid/usr/Version
  echo
  echo "* Xamarin.iOS"
  /Developer/MonoTouch/usr/bin/mtouch --version
  echo
  echo "--- Android"
  echo
  echo "* ANDROID_HOME (${ANDROID_HOME}) content:"
  ls -alh ${ANDROID_HOME}
  echo
  echo "* ANDROID_NDK_HOME (${ANDROID_NDK_HOME}) content:"
  ls -alh ${ANDROID_NDK_HOME}
  echo
  echo "* platform-tools content:"
  ls -1 ${ANDROID_HOME}/platform-tools
  echo
  echo "* build-tools content:"
  ls -1 ${ANDROID_HOME}/build-tools
  echo
  echo "* extras content:"
  tree -L 2 ${ANDROID_HOME}/extras
  echo
  echo "* extra-android-support package version:"
  cat ${ANDROID_HOME}/extras/android/support/source.properties | grep 'Pkg.Revision='
  echo
  echo "* platforms content:"
  ls -1 ${ANDROID_HOME}/platforms
  echo
  echo "* system-images content:"
  tree -L 3 ${ANDROID_HOME}/system-images
  echo "========================================"
  echo
fi

echo
echo "=== Environment infos ======================="
if [ -z "${MATCH_KEYCHAIN_PASSWORD}" ] ; then
  echo "MATCH_KEYCHAIN_PASSWORD environment NOT set"
  exit 1
else
  echo "MATCH_KEYCHAIN_PASSWORD environment set"
fi
echo "========================================"
echo

echo
echo "=== Control tests ======================"
# these things should pass;
# e.g. testing the existence of specific paths
# or whether ~/.bash_profile can be "source"-d in "set -e" mode
set -e
echo 'source $HOME/.bash_profile ...'
source $HOME/.bash_profile
echo 'source $HOME/.bash_profile - PASSED'
echo "========================================"
echo
