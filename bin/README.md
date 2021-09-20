# FBLinkBuilder&#46;py

## About
This tool extracts deeplinks directly from Facebook APK files and constructs deeplink lists (output path: "FBLinktester/deeplinks.txt"). It includes slight modifications of this [original tool](https://github.com/ashleykinguk/FBLinkBuilder).

![FBLinkBuilder][FBLinkBuilder-light]
![FBLinkBuilder][FBLinkBuilder-dark]

## Usage
```bash
# Run FBLinkBuilder.py
$ python3 ./FBLinkBuilder.py <Options: -i [INPUT_FILE] [-e] [-r] [-v] [-h]>
```

<details>
  <summary><strong>Read more about options</strong></summary><br>

  | Flag | Description | Default |
  |------|-------------| ------- |
  | -i, --input | Input path of .apk file **(Required)** | - |
  | -e, --exported | Filter exported deeplinks | false |
  | -r, --required | Filter non-required parameters from deeplinks | false |
  | -v, --verbose | Display verbose output | false |
  | -h, --help | Display this help and exit | |

[FBLinkBuilder-light]: https://raw.githubusercontent.com/dhtzs/FBLinkTester/main/assets/FBLinkBuilder-light.png#gh-light-mode-only
[FBLinkBuilder-dark]: https://raw.githubusercontent.com/dhtzs/FBLinkTester/main/assets/FBLinkBuilder-dark.png#gh-dark-mode-only