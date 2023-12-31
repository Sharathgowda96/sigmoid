#creating users
resource "aws_iam_user" "newusers" {
  count = length(var.username)
  name  = var.username[count.index]
}

resource "aws_iam_user_policy_attachment" "s3-user-full" {
  count = length(var.username)
  user  = element(aws_iam_user.newusers.*.name, count.index)
  #policy_arn = "${aws_iam_policy.ec2_readonly.arn}"
  policy_arn = aws_iam_policy.s3_full_access.arn
}
