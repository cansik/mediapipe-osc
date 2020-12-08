PoseClient client;

void setup() {
  size(500, 500);
  
  client = new PoseClient(7500);
}

void draw() {
  background(55);
  
  if(client.poseCount > 0) {
    // draw pose
    for(KeyPoint kp : client.pose.keypoints) {
      noStroke();
      fill(255);
      circle(kp.x * width, kp.y * height, 10);
    }
  }
}
