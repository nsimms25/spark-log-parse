#!/bin/bash

echo "Starting install and setup"

#Update and Upgrade Ubuntu install to make sure repos and version is most up to date.
sudo apt update && sudo apt upgrade -y

#Install Java for in order to use Hadoop, check version.
sudo apt install openjdk-11-jdk 
java --version

#Install SSH for localhost Hadoop
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh
ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#Install Python3 and useful modules for setup.
sudo apt install python3 python3-pip python3-venv

#Setup python3 venv and install python3 modules that will be used. 
python3 -m venv hadoop-spark-env
source hadoop-spark-env/bin/activate
pip install --upgrade pip
pip install pyspark numpy pandas

#Add user for hadoop
sudo adduser hadoopuser
sudo usermod -aG sudo hadoopuser
su - hadoopuser

#Get 3.3.6 Hadoop version, uncompress, and move to new directory hadoop.
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xvzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 ~/hadoop

echo "export HADOOP_HOME=$HOME/hadoop" >> ~/.bashrc
echo "export HADOOP_INSTALL=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export YARN_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc

source ~/.bashrc

#Change to directory to alter a couple Hadoop files.
cd "$HADOOP_HOME/etc/hadoop" || exit 1

file="core-site.xml"

# Backup file in case.
cp "$file" "$file.bak"

# Overwrite with new content
cat <<EOF > "$file"
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

echo "Updated $file."

# Change hdfs-site.xml
file="hdfs-site.xml"

# Backup file in case.
cp "$file" "$file.bak"

# Overwrite with new content
cat <<EOF > "$file"
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///path/to/hadoop_data/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///path/to/hadoop_data/hdfs/datanode</value>
  </property>
</configuration>
EOF

echo "Updated $file."

cd $HADOOP_HOME

hdfs namenode -format

start-dfs.sh
start-yarn.sh

#Using JPS to check nodes and services. 
echo "Checking Hadoop nodes and services are running"
jps

#Time to test HDFS
echo "make a directory with a test file in order to test upload."
hdfs dfs -mkdir /test
echo "hello hdfs" > hello.txt
hdfs dfs -put hello.txt /test

#Verify reading HDFS
echo "Testing if file is readable"
hdfs dfs -cat /test/hello.txt
