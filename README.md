## Intro
this repository contains sample code to make all the building blocks described in the paper ...

In particular, this repository contains code that let you:

1. create a secret (hash preimage) using multiparti computation
1. create and threshold-sign transactions using ECDSA in Bitcoin
1. create and threshold-sign transactions using ECDSA in Ethereum

## Cloning
Clone the repository by doing !!!!NEED TO CHECK THE COMMAND!!!!
```sh
git clone -recursive
```
This way you download all the needed submodules.


## multiparty ecdsa
Enter the directory `multi-party-ecdsa/`
    1.  The parameters `parties` and `threshold` can be configured by changing the file: `param`. a keygen will run with `parties` parties and signing will run with any subset of `threshold + 1` parties. `param` file should be located in the same path of the client softwares.
        1. In our specific example, `parties=3` and `threshold=2` so that all parties are required to threshold-sign the transaction to broadcast it
    2. Run `cargo build --release --examples` 
Run `cd ../files` to exit the directory
    Run `sh install.sh`. this will copy the new files into the `multi-party-ecdsa/` directory

## mp-spdz
1. install things
1. Run `make -j mpir`
1. Run `make -j shamir-party.x`
1. Run `./compile.py tutorial`
    1. Run `echo 1 2 3 4 > Player-Data/Input-P0-0`
    1. Run `echo 1 2 3 4 > Player-Data/Input-P1-0`
1. Run `Scripts/setup-ssl.sh [<number of parties>]`
1. Run `Scripts/shamir.sh tutorial #no typo` 
