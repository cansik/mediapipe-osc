import argparse

import cv2
import mediapipe as mp
from mediapipe.framework.formats import landmark_pb2
from pythonosc import udp_client
from pythonosc.osc_message_builder import OscMessageBuilder

from utils import add_default_args, get_video_input

OSC_ADDRESS = "/mediapipe/faces"


def send_faces(client: udp_client,
               detections: [landmark_pb2.NormalizedLandmarkList]):
    if detections is None:
        client.send_message(OSC_ADDRESS, 0)
        return

    # create message and send
    builder = OscMessageBuilder(address=OSC_ADDRESS)
    builder.add_arg(len(detections))
    for detection in detections:
        rbb = detection.location_data.relative_bounding_box

        builder.add_arg(rbb.xmin)
        builder.add_arg(rbb.ymin)
        builder.add_arg(rbb.width)
        builder.add_arg(rbb.height)
        builder.add_arg(detection.score[0])

    msg = builder.build()
    client.send(msg)


def main():
    # read arguments
    parser = argparse.ArgumentParser()
    add_default_args(parser)
    args = parser.parse_args()

    # create osc client
    client = udp_client.SimpleUDPClient(args.ip, args.port)

    mp_drawing = mp.solutions.drawing_utils
    mp_face_detection = mp.solutions.face_detection

    hands = mp_face_detection.FaceDetection(model_selection=0, min_detection_confidence=0.5)
    cap = cv2.VideoCapture(get_video_input(args.input))
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            break

        # Flip the image horizontally for a later selfie-view display, and convert
        # the BGR image to RGB.
        image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)
        # To improve performance, optionally mark the image as not writeable to
        # pass by reference.
        image.flags.writeable = False
        results = hands.process(image)

        send_faces(client, results.detections)

        # Draw the hand annotations on the image.
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        if results.detections:
            for detection in results.detections:
                mp_drawing.draw_detection(
                    image, detection)
        cv2.imshow('MediaPipe OSC Faces', image)
        if cv2.waitKey(5) & 0xFF == 27:
            break
    hands.close()
    cap.release()


if __name__ == "__main__":
    main()
