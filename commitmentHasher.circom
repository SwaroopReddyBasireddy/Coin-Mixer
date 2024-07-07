pragma circom  2.0.0;

include "../circomlib/circuits/bitify.circom";
include "../circomlib/circuits/pedersen.circom";

// computes Pedersen(nullifier + secret)
template CommitmentHasher() {
    signal input nullifier;
    signal input secret;
    signal output nullifierHash;
    signal output commitment;

    component commitmentHasher = Pedersen(496);
    component nullifierHasher = Pedersen(248);
    component nullifierBits = Num2Bits(248);
    component secretBits = Num2Bits(246);

    nullifierBits.in <== nullifier;
    secretBits.in <== secret;

    var i;
    for(i = 0; i < 248; i++){
        nullifierHasher.in[i] <== nullifierBits.out[i];
        commitmentHasher.in[i] <== nullifierBits.out[i];
        commitmentHasher.in[248+i] <== secretBits.out[i];
    }

    commitment <== commitmentHasher.out[0];
    nullifierHash <== nullifierHasher.out[0];
}

/* INPUT = {
    "nullifier": "1",
    "secret": "100"
} */



