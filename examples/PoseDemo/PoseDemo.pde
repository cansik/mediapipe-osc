PoseClient client;

void setup() {
  size(500, 500);
  colorMode(HSB, 360, 100, 100);

  client = new PoseClient(7500);
}

void draw() {
  background(55);

  if (client.poseCount > 0) {

    // draw skeleton
    strokeWeight(4);
    noFill();

    for (int i = 0; i < POSE_CONNECTIONS.length; i += 2) {
      KeyPoint a = client.pose.keypoints[POSE_CONNECTIONS[i]];
      KeyPoint b = client.pose.keypoints[POSE_CONNECTIONS[i+1]];

      stroke(map(i, 0, POSE_CONNECTIONS.length, 0, 360), 80, 100);
      line(a.x * width, a.y * height, b.x * width, b.y * height);
    }

    // draw pose keypoints
    for (KeyPoint kp : client.pose.keypoints) {
      noStroke();
      fill(255);
      circle(kp.x * width, kp.y * height, 10);
    }
  }
}
