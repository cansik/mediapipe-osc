import argparse

import cv2
import mediapipe as mp
from mediapipe.framework.formats import landmark_pb2
from pythonosc import udp_client
from pythonosc.osc_message_builder import OscMessageBuilder

from utils import add_default_args, get_video_input

OSC_ADDRESS = "/mediapipe/hands"


def send_hands(client: udp_client,
               detections: [landmark_pb2.NormalizedLandmarkList]):
    if detections is None:
        client.send_message(OSC_ADDRESS, 0)
        return

    # create message and send
    builder = OscMessageBuilder(address=OSC_ADDRESS)
    builder.add_arg(len(detections))
    for detection in detections:
        for landmark in detection.landmark:
            builder.add_arg(landmark.x)
            builder.add_arg(landmark.y)
            builder.add_arg(landmark.z)
            builder.add_arg(landmark.visibility)
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
    mp_hands = mp.solutions.hands

    hands = mp_hands.Hands(
        min_detection_confidence=0.7, min_tracking_confidence=0.5)
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

        send_hands(client, results.multi_hand_landmarks)

        # Draw the hand annotations on the image.
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                mp_drawing.draw_landmarks(
                    image, hand_landmarks, mp_hands.HAND_CONNECTIONS)
        cv2.imshow('MediaPipe OSC Hands', image)
        if cv2.waitKey(5) & 0xFF == 27:
            break
    hands.close()
    cap.release()


if __name__ == "__main__":
    main()
