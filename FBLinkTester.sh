#!/bin/bash

# Set global tool variables
tool_name="FBLinkTester"
tool_version="1.0.0"
tool_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set global font/line variables
font_underline="\033[4m"
font_reset="\033[0m"
line_reset="\r\033[1A\033[K"

# Set global option variables
option_custom=""
option_extract=""
option_save=""
option_update=""
option_verbose="&>/dev/null"
option_noColor=""

# Set global functions
Help() {
  echo ""
  echo "usage: ./${tool_name}.sh [-c [PATTERN]] [-e] [-s] [-u] [-v] [-nc] [-h] [-V]"
  echo ""
  echo "description:"
  echo "    ${tool_name} facilitates the entire process of"
  echo "    deeplink testing Facebook's mobile application"
  echo "    on your Android device from your local machine"
  echo ""
  echo "options:"
  echo "    -c, --custom"
  echo "        Generate & select custom deeplinks file from pattern"
  echo "        Use \"gf -list\" command to list available gf patterns"
  echo "        (output path: \"${tool_name}/deeplinks_custom/\")"
  echo "    -e, --extract"
  echo "        Extract Facebook APK file from connected device"
  echo "        (output path: \"${tool_name}/bin/APKs/\")"
  echo "    -s, --save"
  echo "        Save deeplinks for inspection"
  echo "        (output path: \"${tool_name}/deeplinks_saved/\")"
  echo "    -u, --update"
  echo "        Update ${tool_name} to latest version"
  echo "    -v, --verbose"
  echo "        Display verbose output"
  echo "    -nc, --no-color"
  echo "        Disable color output"
  echo "    -h, --help"
  echo "        Display this help and exit"
  echo "    -V, --version"
  echo "        Display ${tool_name} version"
  echo ""
  exit 0
}
Version() {
  echo "${tool_name} version ${tool_version}"
  exit 0
}

# Set global options
positional=()
while [[ $# -gt 0 ]]; do
  option="$1"
  case $option in
	-h|--help)
	  Help; shift;;
	-c|--custom)
	  option_custom=$2; shift; shift;;
	-e|--extract)
	  option_extract=1; shift;;
	-s|--save)
	  option_save=1; shift;;
	-u|--update)
	  option_update=1; shift;;
	-v|--verbose)
	  option_verbose=""; shift;;
	-nc|--no-color)
	  option_noColor=${font_reset}; shift;;
	-V|--version)
	  Version; shift;;
	*)
	  positional+=("$1"); shift;;
  esac
done
set -- "${positional[@]}"

# Set global font-color variables
font_red="\033[0;31m${option_noColor}"
font_yellow="\033[0;33m${option_noColor}"
font_cyan="\033[0;36m${option_noColor}"

# Clear output
clear
printf "\033c\e[3J"

# Show banner
color_code=57
while IFS= read -r line || [[ -n "$line" ]]; do
  ((color_code=color_code+6))
  echo -e "\033[38;5;${color_code}m${option_noColor}$(echo "${line}" | sed -e "s/\${tool_version}/${tool_version}/" -e "s/\${banner_spaces}/$(for i in $(eval echo {1..$((27 - ${#tool_version}))}); do echo -n " "; done)/")${font_reset}"
done < "${tool_dir}/banner.txt"

# Set device checking function
Check_Device() {
  # Check if adb is installed
  if [[ -z "$(which adb)" ]]; then
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} adb is not installed."
	exit 1
  fi
  # Check if adb daemon is running
  if [[ -z $(pgrep -x "adb") ]]; then
	echo -e "\n╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} Starting adb daemon..."
	adb start-server &>/dev/null
	echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} Started adb daemon."
  fi
  # Check if device is connected
  if [[ -z "$(adb devices | grep 'device$')" ]]; then
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} No device connected."
	exit 1
  fi
  # Check if Facebook application is installed on device
  if [[ -z "$(adb shell pm list packages | grep 'com.facebook.katana')" ]]; then
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} Facebook application not installed on connected device."
	exit 1
  fi
}

# Check "custom" option
if [[ -n "$option_custom" ]]; then
  # Check if gf is installed
  if [[ -z "$(which gf)" ]]; then
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} gf is not installed."
	exit 1
  fi
  # Create custom deeplinks folder
  mkdir -p "${tool_dir}/deeplinks_custom"
  file="${tool_dir}/deeplinks_custom/$option_custom.txt"
  # Generate custom deeplinks file
  file_custom=$(cat ${tool_dir}/deeplinks.txt 2>/dev/null | gf "$option_custom" 2>/dev/null)
  echo -n "$file_custom" > "$file"
  if [[ ! -s "$file" ]]; then
	# Delete empty custom deeplinks file
	rm -rf "$file"
  fi
else
  file="${tool_dir}/deeplinks.txt"
fi
# Check "extract" option
if [[ -n "$option_extract" ]]; then
  # Check device
  Check_Device
  # Create APKs folder
  app_output="${tool_dir}/bin/APKs"
  mkdir -p "${app_output}"
  echo -e "\n╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} Getting APK file information from connected device..."
  # Get APK file information
  app_path=$(adb shell pm path com.facebook.katana | head -n 1 | cut -f 2 -d ":")
  app_version=$(adb shell dumpsys package com.facebook.katana| grep versionName | head -n 1 | cut -f 2 -d "=")
  # Extract Facebook APK file
  echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} Extracting APK file from connected device..."
  adb pull "${app_path}" "${app_output}/Facebook_v${app_version//[.]/_}.apk" &>/dev/null
  echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} APK file has been extracted from connected device."
  exit 0
fi
# Check "save" option
if [[ -n "$option_save" ]]; then
  # Create saved deeplinks folder
  mkdir -p "${tool_dir}/deeplinks_saved"
  if [[ -n "$option_custom" ]]; then
	file_for_inspection="${tool_dir}/deeplinks_saved/$option_custom.txt"
  else
	file_for_inspection="${tool_dir}/deeplinks_saved/deeplinks.txt"
  fi
  if [[ ! -s "$file_for_inspection" ]]; then
	# Delete empty saved custom deeplinks file
	rm -rf "$file_for_inspection"
  fi
fi
# Check "update" option
if [[ -n "$option_update" ]]; then
  # Check if there is a ".git" directory
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
	echo -e "\n╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} Checking for version update..."
	eval git fetch ${option_verbose}
	repo_branch=$(git rev-parse --abbrev-ref HEAD)
	repo_headHash=$(git rev-parse HEAD)
	repo_upstreamHash=$(git rev-parse ${repo_branch}@{upstream})
	# Check for version update
	if [[ "$repo_headHash" != "$repo_upstreamHash" ]]; then
	  # Update to latest version
	  echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} There is a new version, updating..."
	  eval git reset --hard "&>/dev/null"
	  eval git pull --rebase "&>/dev/null"
	  echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} ${tool_name} has been updated!"
	else
	  echo -e "${line_reset}╰─> ${font_yellow}${font_underline}Info${font_yellow}:${font_reset} ${tool_name} is already up to date!"
	fi
	exit 0
  else
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} ${tool_name} is missing \".git\" directory."
	exit 1
  fi
fi

# Check if deeplinks file exists
if [[ -s "$file" ]]; then
  # Check device
  Check_Device
  # Start deeplink testing
  deeplink=0
  while read -r line || [[ -n "$line" ]]; do
	((deeplink=deeplink+1))
	echo -e "\n╭─ ${font_yellow}Sending ${font_underline}Deeplink-${deeplink}${font_reset} (Pattern: ${font_cyan}${option_custom:-${font_yellow}default${font_reset}}${font_reset}) [Device: ${font_cyan}$(adb shell getprop ro.product.odm.model </dev/tty)${font_reset}]"
	# Stop running Facebook application activities
	adb shell am force-stop com.facebook.katana </dev/null ${option_verbose}
	# Send deeplink to device
	adb shell am start -W -a "android.intent.action.VIEW" -d "\"$line\"" </dev/null ${option_verbose}
	if [[ -n "$option_save" ]]; then
	  echo -ne "╰─> ${font_yellow}Save deeplink for inspection?${font_reset} [Y/n] > "
	  read -p "" Yy </dev/tty
	  echo -ne ${line_reset}
	  while true; do
		case $Yy in
		  [Yy]* ) echo -e "${line_reset}╰─> ${font_yellow}Saved Deeplink-${deeplink} ${font_yellow}for inspection${font_reset}"; echo "adb shell am start -a \"android.intent.action.VIEW\" -d "\""${line//[&]/\\&}"\""" >> "$file_for_inspection"; cat "$file_for_inspection" | sort -u -o "$file_for_inspection"; break;;
		  * ) break;;
		esac
	  done
	else
	  read -p "$(echo -e "╰─> ${font_yellow}Press [enter] to skip${font_reset}...")" </dev/tty
	  echo -ne ${line_reset}
	fi
  done < "$file"
else
  if [[ -n "$option_custom" ]]; then
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} Pattern not available."
  else
	echo -e "\n╰─> ${font_red}${font_underline}Error${font_red}:${font_reset} No deeplinks file found."
  fi
  exit 1
fi