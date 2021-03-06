yum install -y epel-release wget java-1.8.0-openjdk-devel psmisc lsof
yum update -y
yum clean all

chown -R vagrant /vagrant

cat > /etc/systemd/system/indy.service << '__EOF__'
[Unit]
Description=Indy
Wants=network-online.target
After=network.target network-online.target

[Service]
Restart=always
RestartSec=10
ExecStart=/bin/bash -l /vagrant/indy-scripts/start-indy.sh
ExecStop=/usr/bin/killall java

[Install]
WantedBy=multi-user.target
__EOF__

systemctl daemon-reload

systemctl disable firewalld
systemctl stop firewalld

# firewall-cmd --permanent --zone=public --add-port=8080/tcp
# firewall-cmd --permanent --zone=public --add-port=8081/tcp
# firewall-cmd --permanent --zone=public --add-port=8000/tcp
# firewall-cmd --reload

systemctl enable indy
systemctl start indy
