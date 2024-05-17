#Create EKS cluster. 
#Kubernetes clusters managed by Amazon EKS make calls to other AWS services on your behalf 
#to manage the resources that you use with the service. 
#For example, EKS will create an autoscaling group for each instance group if you use managed nodes.
# Before you can create Amazon EKS clusters, you must create an IAM role with the AmazonEKSClusterPolicy.

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "my_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_az1.id,
      aws_subnet.private_subnet_az2.id,
      aws_subnet.public_subnet_az1.id,
      aws_subnet.public_subnet_az2.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.my_cluster_AmazonEKSClusterPolicy]
}
