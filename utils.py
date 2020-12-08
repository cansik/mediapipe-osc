from argparse import ArgumentParser


def add_default_args(parser: ArgumentParser):
    parser.add_argument("--device", type=int, default=0,
                        help="The id of the capture device (camera)")

    parser.add_argument("-mdc", "--min-detection-confidence", type=float, default=0.5,
                        help="Minimum confidence value ([0.0, 1.0]) for the detection to be considered successful.")
    parser.add_argument("-mtc", "--min-tracking-confidence", type=float, default=0.5,
                        help=" Minimum confidence value ([0.0, 1.0]) to be considered tracked successfully.")

    parser.add_argument("--ip", default="127.0.0.1",
                        help="The ip of the OSC server")
    parser.add_argument("--port", type=int, default=7500,
                        help="The port the OSC server is listening on")