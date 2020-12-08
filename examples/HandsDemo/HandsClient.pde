import oscP5.*;

final int KEY_POINT_COUNT = 25;

class HandsClient {
  private OscP5 osc;

  public volatile int poseCount = 0;
  public volatile Hand pose;

  public HandsClient(int port) {
    pose = new Hand();
    osc = new OscP5(this, port);
  }

  private synchronized void oscEvent(OscMessage msg) {
    if (msg.checkAddrPattern("/mediapipe/hands")) {
      updatePose(pose, msg);
      return;
    }
  }

  private void updatePose(Hand pose, OscMessage msg) {
    poseCount = msg.get(0).intValue();

    if (poseCount == 0) return;

    for (int i = 0; i < KEY_POINT_COUNT; i++) {
      int index =  1 + (i * 4);
      pose.keypoints[i].x = msg.get(index++).floatValue();
      pose.keypoints[i].y = msg.get(index++).floatValue();
      pose.keypoints[i].z = msg.get(index++).floatValue();
      pose.keypoints[i].visibility = msg.get(index++).floatValue();
    }
  }
}

class Hand {
  KeyPoint[] keypoints;

  public Hand() {
    keypoints = new KeyPoint[KEY_POINT_COUNT];
    for (int i = 0; i < keypoints.length; i++) {
      keypoints[i] = new KeyPoint();
    }
  }
}

class KeyPoint extends PVector {
  float visibility = 0.0;
}
