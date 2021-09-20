# FBLinkTester

[![Release][badge-release-src]][badge-release-href]
[![Downloads][badge-downloads-src]][badge-downloads-href]
[![License][badge-license-src]][badge-license-href]

## About
FBLinkTester facilitates the entire process of deeplink testing Facebook's mobile application on your Android device from your local machine.

![FBLinkTester][FBLinkTester-light]
![FBLinkTester][FBLinkTester-dark]

## How it works
FBLinkTester is not full-featured yet but it helps you run automatic deeplink tests on Facebook's Android application out of deeplink lists with the help of `adb` and `gf` with ease.

> Android Debug Bridge (`adb`) is a versatile command-line tool that lets you communicate with a device. It's used to let you deploy deeplink tests on your Android device.

> `gf` is a wrapper around grep (command-line utility for searching plain-text data sets for lines that match a regular expression) to avoid typing common patterns. It's used to let you generate custom deeplink lists.

Deeplink lists can be extracted directly from Facebook APK files using FBLinkBuilder&#46;py, a Python3 script included in the project ("FBLinkTester/bin/").

## Requirements
- [Android SDK Platform-Tools](https://developer.android.com/studio/releases/platform-tools)
- [gf](https://github.com/tomnomnom/gf) (@TomNomNom)
- [Python3](https://www.python.org/downloads)

## Installation & usage
As a first step, confirm that [Facebook Android application](https://play.google.com/store/apps/details?id=com.facebook.katana) is installed on your device. In addition, make sure that your device is connected to your local machine using the `adb` daemon over USB or Wi-Fi ([instructions](https://developer.android.com/studio/command-line/adb)).

```bash
# Clone repository
$ git clone https://github.com/dhtzs/FBLinkTester
# Navigate to repository directory
$ cd FBLinkTester/
# Make FBLinkTester executable
$ chmod +x FBLinkTester.sh
# Run FBLinkTester
$ ./FBLinkTester.sh <Options: [-c [PATTERN*]] [-e] [-s] [-u] [-nc] [-h] [-v]>
```

<details>
  <summary><strong>Read more about options and patterns</strong></summary><br>

  | Flag | Description | Default |
  |------|-------------| ------- |
  | -c, --custom | Generate & select custom deeplinks file from pattern <br> Use "gf -list" command to list available gf patterns <br> (output path: "FBLinkTester/deeplinks_custom/") | - |
  | -e, --extract | Extract Facebook APK file from connected device <br> (output path: "FBLinkTester/bin/APKs/") | |
  | -s, --save | Save deeplinks for inspection <br> (output path: "FBLinkTester/deeplinks_saved/") | false |
  | -u, --update | Update FBLinkTester to latest version | |
  | -v, --verbose | Display verbose output | false |
  | -nc, --no-color | Disable color output | false |
  | -h, --help | Display this help and exit | |
  | -V, --version | Display FBLinkTester version | |

  *`gf` comes bundled with some pre-configured example patterns:

  ```bash
  # Install gf
  $ go get -u github.com/tomnomnom/gf
  # Copy example patterns to patterns directory
  $ cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
  # Display available patterns
  $ gf -list
  ```

  Additional patterns can easily be added to the list. You can discover and obtain more patterns from the GitHub community, e.g:

  ```bash
  # Clone repository
  $ git clone https://github.com/1ndianl33t/Gf-Patterns
  # Navigate to repository directory
  $ cd Gf-Patterns/
  # Move patterns to patterns directory
  $ mv *.json ~/.gf
  # Display available patterns
  $ gf -list
  ```
</details>

## Support
Need help? Please, open an issue for support. If you have more questions, feel free to contact me on [Twitter][social-href].

## License
This project is licensed under the terms of the [MIT License][license-href]. See the [LICENSE](LICENSE) file for license rights and limitations.

## Contributing
Interested in contributing? You are more than welcome to contribute to this repository as much as you wish.

## Sponsorsing
[![Sponsorsing][funding-src]][funding-href] <br> Want to support? You can buy me a coffee for my effort in developing this project.

[badge-release-src]: https://img.shields.io/github/v/release/dhtzs/FBLinkTester?style=flat&logo=github&logoColor=white
[badge-downloads-src]: https://img.shields.io/github/downloads/dhtzs/FBLinkTester/total?style=flat&logo=github&logoColor=white
[badge-license-src]: https://img.shields.io/github/license/dhtzs/FBLinkTester?style=flat&logo=github&logoColor=white
[badge-release-href]: https://github.com/dhtzs/FBLinkTester/releases/latest
[badge-downloads-href]: https://github.com/dhtzs/FBLinkTester/releases/latest
[badge-license-href]: https://choosealicense.com/licenses/mit
[FBLinkTester-light]: https://raw.githubusercontent.com/dhtzs/FBLinkTester/main/assets/FBLinkTester-light.png#gh-light-mode-only
[FBLinkTester-dark]: https://raw.githubusercontent.com/dhtzs/FBLinkTester/main/assets/FBLinkTester-dark.png#gh-dark-mode-only
[social-href]: https://twitter.com/dhtzs
[license-href]: https://choosealicense.com/licenses/mit
[funding-src]: https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png
[funding-href]: https://www.buymeacoffee.com/dhtzs