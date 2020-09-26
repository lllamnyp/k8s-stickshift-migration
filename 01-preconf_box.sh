#!/bin/bash

echo Creating ssh keypair
ssh-keygen -t rsa -N '' -f ./devopslive_rsa <<<y
cp devopslive_rsa.pub basebox/pre/

echo Removing previously existing preconfigured boxes
echo
rm -f basebox/node.box 
vagrant box remove devopslive
echo
echo Building preconfigured base box
echo
cd basebox/pre/

vagrant destroy -f && vagrant up
echo
echo Packaging box...
echo
vagrant package --output ../node.box devopslive
echo
echo Removing VM...
echo
vagrant destroy -f
echo
echo Saving image locally
echo
cd ../post
vagrant destroy -f && vagrant up
vagrant destroy -f
cd ..
echo
echo Done!
