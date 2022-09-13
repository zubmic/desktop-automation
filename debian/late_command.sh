#!/bin/bash

# Set python3 as the default python
update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# Clone the repo and run the playbook
git clone https://github.com/zubmic/desktop-automation.git
cd desktop-automation
ansible-playbook ansible/main.yml