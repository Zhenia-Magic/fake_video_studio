/*
 * Code to create key pair for the EC2
 */

resource "aws_key_pair" "default" {
  key_name   = "fake-video-studio"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFt5mIF21sLD4YHBFs3lIoeGZeCKl0HTd745N9bGRGcz33LSprOXnL162T4heHUFrhxxIZWLq2hULb8kK15Q80qZf+Q4JMcJKPPOn41IZcE8z8BGX7SdiDDCstFNAXbLIVvMfTJe9FwUNQAvfwhMV9dwhSeFXhmdt5F8S79B+1oQQLsGJF9mhdQpSR8zuqqC7SQ6qGwQg6w/qQefQBXMVP9VR9SvW2WWTka5jWCe8TegOepRt7xUQxpgygHPOuD/XpA0+pbO78Jjl4vsAAKJyZEVo0ezMzrTIj3d3lZ5Hf6gOqBCpquWC3ODUnihdlnIkP7UGqm1f+c29CioemXceqimax4M1GAwAqsTjmzYA3rj7PuVZJ91eo0+h38zDdwrmL5tzOJrTyTWtDbxHElPRgwpqQ61PJGPiPLtyKGI8QH5shyiswNnGLqmFNegfnxMJ3lqOmG7St5nDTmJWTrr4PPfKTzsRTUZsmqQ99TQJZR/S6YMPrkohEcoO6Ng30MK1Qw4zXGib+FAPeDLwBdT1uYX+/HQiDymtoH1n2SoLqV/o2LxYrEuSE6hDVXSCIomwYkKkQT5yLcq9gRzwAbabqLII03fJYsdCUlEChbAE/8exsIttB1UZYNMPxJp5JsiOrh2VoGWY1l9ivlIXmo/Qb7fYoC5D/Wvr2SEHy3WERBw== evgeniia@uni.minerva.edu"

  tags = {
    "Name" = "evgeniia@uni.minerva.edu"
  }
}
