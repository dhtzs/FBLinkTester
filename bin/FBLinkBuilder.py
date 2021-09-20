import os
import argparse
import json
import re
from zipfile import ZipFile

print("")

def apk_format(path):
	if not path.endswith(".apk"):
		raise argparse.ArgumentTypeError("Input file should have .apk file format.")
	return path

parser = argparse.ArgumentParser(
	formatter_class=argparse.RawDescriptionHelpFormatter,
	usage=os.path.basename(__file__)+" -i [INPUT_FILE] [-e] [-r] [-v] [-h]",
	description="This tool extracts deeplinks directly from\nFacebook APK files and constructs deeplink lists.\nIt includes slight modifications of this original tool:\nhttps://github.com/ashleykinguk/FBLinkBuilder"
)
parser.add_argument("-i", "--input", dest="input_file", help="input path of .apk file (Required: True)", nargs="?", type=apk_format, required=True)
parser.add_argument("-e", "--exported", dest="exported", help="filter exported deeplinks (default: False)", action="store_true")
parser.add_argument("-r", "--required", dest="required", help="filter non-required parameters from deeplinks (default: False)", action="store_true")
parser.add_argument("-v", "--verbose", dest="verbose", help="display verbose output (default: False)", action="store_true")
args = parser.parse_args()

input_file = args.input_file
exported = args.exported
required = args.required
verbose = args.verbose

try:
	with ZipFile(input_file, "r") as zip:
		try:
			data = zip.read("assets/react_native_routes.json")
			js = json.loads(data.decode("utf-8"))
			print("Extracting \"assets/react_native_routes.json\" from APK file...")
			params = ""
			deeplinks = 0

			if verbose:
				print("\n╭─> Manipulating data...")
			file_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "/deeplinks.txt"
			file = open(file_path, "w")
			for route in js:

				count_default = 1
				count_param_string = 0
				count_param_float = 0
				count_param_bool = 0

				for idx,route_param in enumerate(route["paramDefinitions"]):

					route_param_type = route["paramDefinitions"][route_param]["type"]
					if required and str(route["paramDefinitions"][route_param]["required"]) == "False":
						params += ""
					else:
						if route_param_type == "String":
							count_param_string += 1
							count_default = count_param_string
						elif route_param_type == "Float":
							count_param_float += 1
							count_default = count_param_float
						elif route_param_type == "Bool":
							count_param_bool += 1
							count_default = count_param_bool
						params += route_param + "=" + str(route["paramDefinitions"][route_param]["type"]).upper() + str(count_default) + "&"
				if exported and route.get("access", "") != "exported":
					params = ""
					continue

				deeplink = "fb:/" + route["path"] + "/?" + params
				file.write(deeplink[:-1] + "\n")
				deeplinks += 1
				params = ""

				if verbose:
					print("├ " + re.sub(r"\?.*", "", deeplink))
			file.close()
			if verbose:
				print("╰─> Deeplinks generated: " + str(deeplinks) + "\n")
			print("File saved at \"" + os.path.abspath(file.name) + "\"")
			print("{filename: " + os.path.basename(file_path) + ", filesize: " + str(os.path.getsize(file_path)) + " bytes}")
		except KeyError:
			print("\nError: Could not find \"assets/react_native_routes.json\" in APK file.")
except IOError:
	print("\nError: Could not find \"" + input_file + "\" file.")