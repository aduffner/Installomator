universe)
    name="Universe"
    type="dmg"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep universe | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | head -n 30 | sort -gru
    }
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Universe" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
    if [[ "$appNewVersion" =~ ^[^.]*\.[^.]*$ ]]; then
	    appNewVersion=$(sed 's/\([0-9]*\.[0-9]*\)/\1.0/' <<<"$appNewVersion")
    fi
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/universe/releases/${appNewVersion}/Universe-${appNewVersion}_Mac.dmg"
    universeResponse=$(curl -s -I -L "$downloadURL")
    universeHttpStatus=$(echo "$universeResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "universeHttpStatus" == "200" ]]; then
      printlog "DownloadURL HTTP status code: $universeHttpStatus" INFO
    elif [[ "$universeHttpStatus" == "404" ]]; then
      downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/universe/releases/${appNewVersion}/Universe-${appNewVersion}_mac.dmg"
      printlog "Had to change DownloadURL due HTTP Status." INFO
    else
      printlog "Unexpected HTTP status code: $universeHttpStatus" ERROR
    fi
    installerTool="Universe Installer.app"
    CLIInstaller="Universe Installer.app/Contents/MacOS/Universe Installer"
    expectedTeamID="4ZY22YGXQG"
    ;;
