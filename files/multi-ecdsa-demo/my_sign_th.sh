#!/usr/bin/env bash
cargo +nightly build --examples --release

file_as_string=`cat params.json`
digest="`cat /Users/fadi/Projects/threshold-bitcoin/digest.txt`"
# echo "digest is"
# echo $digest
n=`echo "$file_as_string" | cut -d "\"" -f 4 `
t=`echo "$file_as_string" | cut -d "\"" -f 8 `

echo "Multi-party ECDSA parties:$n threshold:$t"
#clean
sleep 1

# rm keys?.store
# killall sm_manager gg18_keygen_client gg18_sign_client 2> /dev/null

./target/release/examples/sm_manager &

# sleep 2
# echo "keygen part"

# for i in $(seq 1 $n)
# do
#     echo "key gen for client $i out of $n"
#     ./target/release/examples/gg18_keygen_client http://127.0.0.1:8001 keys$i.store &
#     sleep 3
# done

# export PWD="$HOME/Projects/multi-party-ecdsa"
# ./target/release/examples/sm_manager &
message=$1

echo "the message is" >2
echo $message >2
echo
sleep 3
echo "sign"

for i in $(seq 1 $((t+1)));
do
    echo "signing for client $i out of $((t+1))"
    RUST_BACKTRACE=full ./target/release/examples/gg18_sign_client http://127.0.0.1:8001 keys$i.store "$message" &
    sleep 3
done

killall sm_manager 2> /dev/null
