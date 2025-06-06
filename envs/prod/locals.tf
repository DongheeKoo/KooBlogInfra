locals {
  vpc_name = "koo-blog"
  vpc_cidr = "10.1.0.0/16"
  public_subnet = {
    cidr_block        = "10.1.0.0/18"
    availability_zone = "ap-northeast-2a"
  }
  private_subnet = {
    cidr_block        = "10.1.64.0/18"
    availability_zone = "ap-northeast-2a"
  }
}
