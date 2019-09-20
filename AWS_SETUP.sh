# Steps to follow
# First we need an AWS account and access keys to start with. 
#   Login to your AWS console and generate access keys for your 
#   user by navigating to Users/Security credentials page.

# Install AWS CLI by
brew install awscli
brew install kops

# Create a new IAM user or use an existing IAM user and grant 
# following permissions:
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
AmazonVPCFullAccess

# Configure the AWS CLI by providing the Access Key, Secret 
# Access Key and the AWS region that you want the Kubernetes 
# cluster to be installed:
aws configure
#   AWS Access Key ID [None]: AccessKeyValue
#   AWS Secret Access Key [None]: SecretAccessKeyValue
#   Default region name [None]: us-east-1
#   Default output format [None]:

# Create an AWS S3 bucket for kops to persist its state:
#   Set Bucket Name
bucket_name=imesh-kops-chriswinn
#   Created an AWS S3 bucket  
aws s3api create-bucket --bucket ${bucket_name} --region us-east-1
# Enable versioning for the above S3 bucket:
aws s3api put-bucket-versioning --bucket ${bucket_name} --versioning-configuration Status=Enabled

# Provide a name for the Kubernetes cluster and set the S3 
# bucket URL in the following environment variables:
#    NOTE: Below code block can be added to the ~/.bash_profile 
#    or ~/.profile file depending on the operating system 
#    to make them available on all terminal environments.
export KOPS_CLUSTER_NAME=imesh.k8s.local
export KOPS_STATE_STORE=s3://${bucket_name}

# Create a Kubernetes cluster definition using kops by providing 
# the required node count, node size, and AWS zones. The node size 
# or rather the EC2 instance type would need to be decided according 
# to the workload that you are planning to run on the Kubernetes cluster:
kops create cluster --node-count=2 --node-size=t2.medium --zones=us-east-1a --name=${KOPS_CLUSTER_NAME}

#     NOTE: If you are seeing any authentication issues, try to set the 
#     following environment variables to let kops directly read EC2 
#     credentials without using the AWS CLI:
      export AWS_ACCESS_KEY=AccessKeyValue
      export AWS_SECRET_KEY=SecretAccessKeyValue
#     If needed execute the kops create cluster help command to find 
#     additional parameters:
      kops create cluster --help

# Review the Kubernetes cluster definition by executing the below command: 
kops edit cluster --name ${KOPS_CLUSTER_NAME}

# Now, let’s create the Kubernetes cluster on AWS by executing 
# kops update command:
kops update cluster --name ${KOPS_CLUSTER_NAME} --yes
      # Above command may take some time to create the required 
      # infrastructure resources on AWS. Execute the validate command 
      # to check its status and wait until the cluster becomes ready:
      kops validate cluster
      # Once the above process completes, kops will configure the 
			# Kubernetes CLI (kubectl) with Kubernetes cluster API endpoint 
			# and user credentials.

# Now, you may need to deploy the Kubernetes dashboard to access 
# the cluster via its web based user interface:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# Execute the below command to find the admin user’s password:
kops get secrets kube --type secret -oplaintext

# Execute the below command to find the Kubernetes master hostname:
kubectl cluster-info
      # Kubernetes master is running at https://api-imesh-k8s-local-<dynamic-id>.us-east-1.elb.amazonaws.com
      # KubeDNS is running at https://api-imesh-k8s-local-<dynamic-id>.us-east-1.elb.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

# Access the Kubernetes dashboard using the following URL:
https://<kubernetes-master-hostname>/ui

# Provide the username as admin and the password obtained above
# on the browser’s login page:
echo "[in browser]"

# Execute the below command to find the admin service account 
# token. Note the secret name used here is different from the previous one:
kops get secrets admin --type secret -oplaintext

# Provide the above service account token on the service token request page:
echo "[in browser]"

# References:
#   [1] Kubernetes Turn-key Cloud Solutions, Kubernetes Documentation:
echo "https://kubernetes.io/docs/getting-started-guides/aws/"
#   [2] Kubernetes Operations Documentation:
echo "https://github.com/kubernetes/kops/tree/master/docs"
#   [3] AWS Managed Kubernetes Service:
echo "https://aws.amazon.com/eks/"
#   [4] AWS Instance Types:
echo "https://aws.amazon.com/ec2/instance-types/"

