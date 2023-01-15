#!/bin/bash

# Encrypt file with -e 
# Decrypt with -d
# verbosity -v




usage() {
    echo "Usage: ${0} [-v] [-e PATH FOR INPUT FOLDER TO ENCRYPT] [-d PATH FOR INPUT FOLDER TO DECRYPT]" >&2
    echo "Encrypt or decrypt files in a specified folder, protecting them with a password"
    echo ' -v               Increase output verbosity. Set This First'
    echo ' -e   FILENAME    specify target folder. All files within it will be encrypted'
    echo ' -d   FILENAME    specify target folder. All files within it will be decrypted (password required)'
    exit 1
}

display(){
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi
}


clean(){
    local TARGET="${@}"
    for fl in $(ls ${FOLDER})
    do
        if [[ $fl != *.$TARGET ]] 
        then
            rm ${FOLDER}/${fl}
            display "Attempting to delete ${fl}"
        fi
    done
}


encrypt(){
    for fl in $(ls ${FOLDER})
    do
        display "Encrypting ${fl}"
        display "write to ${DESTINATION}/${fl}" 
        openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -in ${FOLDER}/${fl} -out ${FOLDER}/${fl}.enc
    done
    if [[ $? -eq 0 ]] 
    then
      clean "enc"
    fi
}


decrypt(){
    for fl in $(ls ${FOLDER})
    do
        display "decrypting ${fl}"
        if [[  $fl == *.enc ]]
        then
            local name=${fl%.enc}
            echo "SWAP ${fl} for ${name}"
            openssl enc -aes-256-cbc -md sha512 -pbkdf2 -in ${FOLDER}/${fl} -out ${FOLDER}/${name} -d
        fi
    done
    
    if [[ $? -eq 0 ]] 
    then
      clean "txt"
    fi
}



while getopts d:e:o:v OPTION
do 
 case ${OPTION} in
    v)
        VERBOSE='true'
        display 'Verbose mode is on.'
        ;;
    o)
        DESTINATION="${OPTARG}"
        ;;
    d)
        display 'Decrypt Selected'
        FOLDER="${OPTARG}"
        decrypt
        ;;
    e)
        display 'Encrypt Selected'
        FOLDER="${OPTARG}"
        encrypt
        ;;
  
    ?)
        usage
        ;;
 esac
done

    
 





#Encrypt file
#openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -in message.txt  -out message.enc

#Decrypt file
#openssl enc -aes-256-cbc -md sha512 -pbkdf2 -in message.enc -out cleat.txt -d
