pragma circom  2.0.0;

include "../circomlib/circuits/mimcsponge.circom";
include "MerkleTree.circom";

template DualMux() {
    signal input ins[2];
    signal input s;
    signal output out[2];

    s*(s-1) === 0;

    // if s == 0 returns [in[0], in[1]]
    // if s == 1 returns [in[1], in[0]]
    out[0] <== (ins[1] - ins[0])*s + ins[0];
    out[1] <== (ins[0] - ins[1])*s + ins[1];
 
}

template merkleTreeChecker(levels) {
    signal input leaf;
    signal input root;
    signal input pathElements[levels];
    signal input pathIndices[levels];

    // signal leafHash;
    // component leafHasher = HashLeftRight();

    // leafHasher.left <== leaf;
    // leafHasher.right <== 0;
    // leafHash <== leafHasher.hash; 

    var i = 0;
    component selectors[levels];
    component hashers[levels];

    log("root: ", root);
   
   
    for (i = 0; i < levels; i++){
        selectors[i] = DualMux();
        selectors[i].ins[0] <== i == 0 ? leaf : hashers[i-1].hash;
        selectors[i].ins[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        log("level ", i);
        log("left: ", selectors[i].ins[0]);
        log("right: ", selectors[i].ins[1]);
        log("Path index: ", selectors[i].s);
        
        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
        log("left: ", hashers[i].left);
        log("right: ", hashers[i].right);


        log("hash: ", hashers[i].hash);
    }
    log("root: ", root);
    log("i: ", i);
    log("Calculated root: ", hashers[i-1].hash);

    root === hashers[i-1].hash;
}

/* INPUT = {
    "leaf": "2",
    "root":"131069759242496036983288064399465818389423939632793442722157738",
    "pathElements": [1,1766646835453], 
    "pathIndices": [1,0]
} */


