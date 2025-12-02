curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.34.2/2025-11-13/bin/linux/amd64/kubectl
sudo cp kubectl /usr/bin/
sudo chmod 777 /usr/bin/kubectl 

sudo yum install -y docker
sudo service docker start

curl "https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh" | sudo bash
sudo EXTERNAL_URL="https://$(hostname)" dnf install -y gitlab-ce
cat /etc/gitlab/initial_root_password

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
