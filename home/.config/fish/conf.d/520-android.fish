if status is-interactive
    if type -q "$HOME/Library/Android/sdk/platform-tools/adb"
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        fish_add_path $HOME/Library/Android/sdk/emulator
        fish_add_path $HOME/Library/Android/sdk/platform-tools
    else
        # echo -e "\e[33mandroid sdk is not installed\e[0m"
    end
end
