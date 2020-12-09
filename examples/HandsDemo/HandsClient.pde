import oscP5.*;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public final int KEY_POINT_COUNT = 21;

class HandsClient {
  private OscP5 osc;
  private List<Hand> hands;

  public HandsClient(int port) {
    hands = new CopyOnWriteArrayList<Hand>();
    osc = new OscP5(this, port);
  }

  public synchronized List<Hand> getHands() {
    return hands;
  }

  private void oscEvent(OscMessage msg) {
    if (msg.checkAddrPattern("/mediapipe/hands")) {
      updateHands(hands, msg);
    }
  }

  private synchronized void updateHands(List<Hand> hands, OscMessage msg) {  
    int handCount = msg.get(0).intValue();

    if (handCount != hands.size()) {
      hands.clear();
      for (int i = 0; i < handCount; i++) {
        hands.add(new Hand());
      }
    }

    for (int h = 0; h < handCount; h++) {
      int offset = 1 + (h * KEY_POINT_COUNT * 4);
      Hand hand = hands.get(h);

      for (int i = 0; i < KEY_POINT_COUNT; i++) {
        int index = offset + (i * 4);
        hand.keypoints[i].x = msg.get(index++).floatValue();
        hand.keypoints[i].y = msg.get(index++).floatValue();
        hand.keypoints[i].z = msg.get(index++).floatValue();
        hand.keypoints[i].visibility = msg.get(index++).floatValue();
      }
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

// keypoint definition
public final int WRIST = 0;
public final int THUMB_CMC = 1;
public final int THUMB_MCP = 2;
public final int THUMB_IP = 3;
public final int THUMB_TIP = 4;
public final int INDEX_FINGER_MCP = 5;
public final int INDEX_FINGER_PIP = 6;
public final int INDEX_FINGER_DIP = 7;
public final int INDEX_FINGER_TIP = 8;
public final int MIDDLE_FINGER_MCP = 9;
public final int MIDDLE_FINGER_PIP = 10;
public final int MIDDLE_FINGER_DIP = 11;
public final int MIDDLE_FINGER_TIP = 12;
public final int RING_FINGER_MCP = 13;
public final int RING_FINGER_PIP = 14;
public final int RING_FINGER_DIP = 15;
public final int RING_FINGER_TIP = 16;
public final int PINKY_MCP = 17;
public final int PINKY_PIP = 18;
public final int PINKY_DIP = 19;
public final int PINKY_TIP = 20;

public final int[] HAND_CONNECTIONS = {
  WRIST, THUMB_CMC, 
  THUMB_CMC, THUMB_MCP, 
  THUMB_MCP, THUMB_IP, 
  THUMB_IP, THUMB_TIP, 
  WRIST, INDEX_FINGER_MCP, 
  INDEX_FINGER_MCP, INDEX_FINGER_PIP, 
  INDEX_FINGER_PIP, INDEX_FINGER_DIP, 
  INDEX_FINGER_DIP, INDEX_FINGER_TIP, 
  INDEX_FINGER_MCP, MIDDLE_FINGER_MCP, 
  MIDDLE_FINGER_MCP, MIDDLE_FINGER_PIP, 
  MIDDLE_FINGER_PIP, MIDDLE_FINGER_DIP, 
  MIDDLE_FINGER_DIP, MIDDLE_FINGER_TIP, 
  MIDDLE_FINGER_MCP, RING_FINGER_MCP, 
  RING_FINGER_MCP, RING_FINGER_PIP, 
  RING_FINGER_PIP, RING_FINGER_DIP, 
  RING_FINGER_DIP, RING_FINGER_TIP, 
  RING_FINGER_MCP, PINKY_MCP, 
  WRIST, PINKY_MCP, 
  PINKY_MCP, PINKY_PIP, 
  PINKY_PIP, PINKY_DIP, 
  PINKY_DIP, PINKY_TIP
};
