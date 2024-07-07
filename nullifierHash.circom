pragma circom  2.0.0;

include "../circomlib/circuits/bitify.circom";
include "../circomlib/circuits/pedersen.circom";

template Nullifier() {

    // Declaration of signals.
    signal input nullifier;
    signal output nullifierHash;

    component  nullifierBits = Num2Bits(248);
    component nullifierHasher = Pedersen(248);

    nullifierBits.in <== nullifier;

    for (var i = 0; i < 248; i++){
        nullifierHasher.in[i] <== nullifierBits.out[i];
    }

    nullifierHash <== nullifierHasher.out[0];

    log("hash", nullifierHash);
}

component main = Nullifier();

/* INPUT = {
    "nullifier": "5",
} */
