HandsClient client;

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100);

  client = new HandsClient(7500);
}

void draw() {
  background(55);

  List<Hand> hands = client.getHands();
  for (int i = 0; i < hands.size(); i++) {
    Hand hand = hands.get(i);
    
    // draw skeleton
    strokeWeight(4);
    stroke(map(i, 0, hands.size(), 0, 360), 80, 100);
    noFill();
    
    for(int j = 0; j < HAND_CONNECTIONS.length; j += 2) {
      KeyPoint a = hand.keypoints[HAND_CONNECTIONS[j]];
      KeyPoint b = hand.keypoints[HAND_CONNECTIONS[j+1]];
      line(a.x * width, a.y * height, b.x * width, b.y * height);
    }
    
    // draw circles with intensity
    noStroke();
    fill(map(i, 0, hands.size(), 0, 360), 80, 100);
    for (KeyPoint kp : hand.keypoints) {
      circle(kp.x * width, kp.y * height, kp.z * 100);
    }
  }
  
  fill(255);
  text("Detected " + hands.size() + " Hand!", 10, 20);
}
