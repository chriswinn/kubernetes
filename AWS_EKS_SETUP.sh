# Install the Weaveworks Homebrew tap.
brew tap weaveworks/tap

# Install or upgrade eksctl.
#   Install eksctl with the following command:
brew install weaveworks/tap/eksctl

#   If eksctl is already installed, run the following command to upgrade:
brew upgrade eksctl && brew link --overwrite eksctl

# Test that your installation was successful with the following command.
eksctl version

# Create your Amazon EKS cluster and worker nodes with the 
# following command. Substitute the red text with your own values.
eksctl create cluster \
--name prod \
--version 1.14 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--node-ami auto

# Note:
# For more information on the available options for eksctl create 
# cluster, see the project README on GitHub or view the help page 
# with the following command.
echo "https://github.com/weaveworks/eksctl/blob/master/README.md"
eksctl create cluster --help

# Cluster provisioning usually takes between 10 and 15 minutes. 
# When your cluster is ready, test that your kubectl configuration 
# is correct.
kubectl get svc


brew install weaveworks/tap/eksctl
