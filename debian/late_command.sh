#!/bin/bash

git clone https://github.com/zubmic/desktop-automation.git
cd desktop-automation
ansible -m ping localhost
sleep 20s