#!bin/bash
set -exuo pipefail
echo "- Starting user_data"
sudo yum update -y
sudo yum install -y docker
sudo service docker start
usermod -a -G docker ec2-user


# Install Git
sudo yum install -y git
git clone https://github.com/shoukoo/rea.git
cd rea
docker build -t rea:latest .
docker run -p 9292:9292 -d rea:latest

# Install nginx
sudo yum install -y nginx
sudo bash -c 'cat << "EOF" > /etc/nginx/conf.d/default.conf
user nginx;

events {
  worker_connections  1024;
}

http {
  upstream sinatra {
    server localhost:9292;
  }

  access_log  /var/log/nginx/access.log;

  server {
    listen   80;
    server_name  $hostname;

    location / {
      proxy_pass http://sinatra;
    }
  }
}
EOF'
sudo sed -i 's/NGINX_CONF_FILE=.*/NGINX_CONF_FILE=\/etc\/nginx\/conf\.d\/default.conf/g' /etc/sysconfig/nginx
sudo service nginx start
touch /tmp/finished-user-data
