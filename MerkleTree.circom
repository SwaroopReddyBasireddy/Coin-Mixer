pragma circom  2.0.0;

include "../circomlib/circuits/mimcsponge.circom";

template HashLeftRight(){
    signal input left;
    signal input right;
    signal output hash;

    component hasher = MiMCSponge(2,2,1);
    hasher.ins[0] <== left;
    hasher.ins[1] <== right;
    hasher.k <== 0;
    hash <== hasher.outs[0]; 
}

template merkleTreeLevel(leafcount, nodecount){    
    signal input leaves[leafcount];
    signal output nodes[nodecount];

    leafcount === 2*nodecount;

    component hashers[nodecount];

    var i = 0;
    var n = 0;

    for (i = 0; i < nodecount; i++){
        hashers[i] = HashLeftRight();
        hashers[i].left <== leaves[n];
        hashers[i].right <== leaves[n+1];

        nodes[i] <== hashers[i].hash;
        n = n+2;
    }
}

template MerkleTree(levels) {
    signal input leaves[2**levels];
    signal output root;

    // var numLeaves = 2**levels;
    // signal leafHashes[numLeaves];
    // component leafHasher[numLeaves];

    // for(var k = 0; k < numLeaves; k++){
    //     leafHasher[k] = HashLeftRight();
    //     leafHasher[k].left <== leaves[k];
    //     leafHasher[k].right <== 0;
    //     leafHashes[k] <== leafHasher[k].hash;
    // }

    var i;
    component merklelevels[levels];
    

    while (i < levels) {
        var leafcount = 2**(levels - i);
        var nodecount = 2**(levels - i - 1);
        merklelevels[i] = merkleTreeLevel(leafcount, nodecount);

        var n;
        log("Level ", i);
        for(n = 0; n < leafcount; n++) {
            merklelevels[i].leaves[n] <== i == 0 ? leaves[n]: merklelevels[i-1].nodes[n];
            log(merklelevels[i].leaves[n]);
        }
        i++;
    }
    root <== merklelevels[i-1].nodes[0];
    log("root", root);
}

/* INPUT = {
    "leaves": [1,2,3,4]
} */


