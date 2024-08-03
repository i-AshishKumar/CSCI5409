resource "aws_s3_bucket" "test" {
  bucket = "cloud-proj-2024"
  force_destroy = true
}

resource "aws_s3_object" "app" {
    bucket = "cloud-proj-2024"
    key = "SnapVault-v1.zip"
    source = "./resources/snapvault.zip"
    depends_on = [ aws_s3_bucket.test ]
}

resource "aws_elastic_beanstalk_application" "eb-app" {
  name = "SnapVault"
  appversion_lifecycle {
    service_role = "arn:aws:iam::862386165175:role/LabRole"
  }
#   depends_on = [ aws_ssm_parameter.api_gw_url ]
}
resource "aws_elastic_beanstalk_environment" "eb-env" {
    name = "SnapVault-env"
    application = aws_elastic_beanstalk_application.eb-app.name
    solution_stack_name = "64bit Amazon Linux 2023 v6.1.7 running Node.js 18"
    version_label = aws_elastic_beanstalk_application_version.app_version.name

    setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "arn:aws:iam::862386165175:instance-profile/LabInstanceProfile"
    }
    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium, t2.small" 
    }
  depends_on = [ aws_elastic_beanstalk_application.eb-app ]
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name = "version-1"
  application = aws_elastic_beanstalk_application.eb-app.name
  key= aws_s3_object.app.id
  bucket = aws_s3_bucket.test.id
  depends_on = [ aws_s3_bucket.test,aws_s3_object.app ]
}