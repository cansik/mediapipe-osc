# Media Pipe OSC
Exposing [mediapipe](https://google.github.io/mediapipe/) examples over OSC to be used in other applications.

### Installation

Currently only MacOS and Linux are supported. It's recommended to use Python3 and a virtual environment.

```bash
python install -r requirements.txt
```

### Pose Landmark Model (BlazePose Tracker)
The landmark model currently included in MediaPipe Pose predicts the location of 25 upper-body landmarks (see figure below), each with (`x, y, z, visibility`). Note that the z value should be discarded as the model is currently not fully trained to predict depth, but this is something we have on the roadmap. The model shares the same architecture as the full-body version that predicts 33 landmarks, described in more detail in the [BlazePose Google AI Blog](https://ai.googleblog.com/2020/08/on-device-real-time-body-pose-tracking.html) and in this [paper](https://arxiv.org/abs/2006.10204).

![Pose Description](readme/pose_tracking_upper_body_landmarks.png)

*[Reference: mediapipe/solutions/pose](https://google.github.io/mediapipe/solutions/pose#pose-landmark-model-blazepose-tracker)*

The OSC message sent by the pose example contains 25 x 4 `float` values.

```
/mediapipe/pose [x, y, z, visibility, x, y, z, visibility ...]
```

### Hand Detection
tbd

### Face Mesh
tbd
