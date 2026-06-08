if [ -f "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"
fi
