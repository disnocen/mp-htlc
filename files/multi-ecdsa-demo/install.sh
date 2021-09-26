#!/bin/sh

echo "Installing files for the Threshold-ECDA library"
cp -v params* ../../multi-party-ecdsa/
cp -v my_keygen_th.sh my_keygen_th_eth.sh my_sign_th.sh ../../multi-party-ecdsa/demo
