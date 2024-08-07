#!/bin/bash
pre_install() {
    sudo apt update && sudo apt upgrade
    sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
    deb http://repo.pritunl.com/stable/apt jammy main
EOF
    
    # Import signing key from keyserver
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    curl https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | sudo apt-key add -

    sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list << EOF
    deb https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse
EOF

}


install_dependencies() {
  wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

  sudo apt update
  sudo apt --assume-yes upgrade

  # WireGuard server support
  sudo apt -y install wireguard wireguard-tools

  sudo ufw disable

  sudo apt -y install pritunl mongodb-org


}

start_server() {
  sudo systemctl enable mongod pritunl
  sudo systemctl start mongod pritunl

}

pre_install
install_dependencies
start_server
