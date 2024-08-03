resource "aws_dynamodb_table" "dynamo_table" {
    name = "users"
    attribute {
      name = "rekognitionId"
      type = "S"
    }
    attribute {
      name = "firstName"
      type = "S"
    }
    attribute {
      name = "lastName"
      type = "S"
    }
    hash_key = "rekognitionId"
    read_capacity = 1
    write_capacity = 1

    global_secondary_index {
    name               = "FirstNameIndex"
    hash_key           = "firstName"
    projection_type    = "ALL"
    read_capacity      = 1
    write_capacity     = 1
  }

    global_secondary_index {
    name               = "LastNameIndex"
    hash_key           = "lastName"
    projection_type    = "ALL"
    read_capacity      = 1
    write_capacity     = 1
  }
}