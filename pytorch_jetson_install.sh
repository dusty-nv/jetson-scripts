#!/bin/bash
#
# pyTorch install script for NVIDIA Jetson TX1/TX2,
# from a fresh flashing of JetPack 2.3.1 / JetPack 3.0
#
# note:  pyTorch documentation calls for use of Anaconda,
#        however Anaconda isn't available for aarch64.
#        Instead, we install directly from source using setup.py
sudo apt-get install python-pip

# upgrade pip
pip install -U pip
pip --version
# pip 9.0.1 from /home/ubuntu/.local/lib/python2.7/site-packages (python 2.7)

# clone pyTorch repo
git clone http://github.com/pytorch/pytorch
cd pytorch

# install prereqs
sudo pip install -U setuptools
sudo pip install -r requirements.txt

# Develop Mode:
python setup.py build_deps
sudo python setup.py develop

# Install Mode:  (substitute for Develop Mode commands)
#sudo python setup.py install

# Verify CUDA (from python interactive terminal)
# import torch
# print(torch.cuda.is_available())
# a = torch.cuda.FloatTensor(2)
# print(a)
# b = torch.randn(2).cuda()
# print(b)
# c = a + b
# print(c)
