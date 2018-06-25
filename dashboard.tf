variable "bucket_name" {
    default = "boom.liatr.io"
}
resource "aws_s3_bucket" "b" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  policy = "${file("policy.json")}"

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

data "aws_route53_zone" "domain" {
  name = "liatr.io"
}

resource "aws_route53_record" "dashboard_url" {
    zone_id = "${data.aws_route53_zone.domain.zone_id}"
    name    = "${var.bucket_name}"
    type    = "A"

    alias {
        name                   = "boom.liatr.io"
        zone_id                = "${aws_s3_bucket.b.hosted_zone_id}"
        evaluate_target_health = true
    }

}
