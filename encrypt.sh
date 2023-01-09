#!/bin/bash

#Encrypt file
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -in message.txt  -out message.enc

#Decrypt file
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -in message.enc -out cleat.txt -d
