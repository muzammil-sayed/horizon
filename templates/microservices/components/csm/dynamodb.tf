/*resource "aws_dynamodb_table" "csm-properties" {
  name             = "csm-properties"
  read_capacity    = 10
  write_capacity   = 10
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "owner"
  range_key        = "key"

  attribute {
    name = "owner"
    type = "S"
  }

  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_dynamodb_table" "csm-services" {
  name           = "csm-services"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "key"
  range_key      = "value"

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "value"
    type = "S"
  }
}*/
