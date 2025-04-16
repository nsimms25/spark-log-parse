#!/bin/bash

echo "Starting install and setup"

#Update and Upgrade Ubuntu install to make sure repos and version is most up to date.
sudo apt update && sudo apt upgrade -y

#Install Java for in order to use Hadoop, check version.
sudo apt install openjdk-11-jdk 
java --version

#Install Python3 and useful modules for setup.
sudo apt install python3 python3-pip python3-venv

#Setup python3 venv and install python3 modules that will be used. 
python3 -m venv hadoop-spark-env
source hadoop-spark-env/bin/activate
pip install --upgrade pip
pip install pyspark numpy pandas
