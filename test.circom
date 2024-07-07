pragma circom  2.0.0;

include "commitmentHasher.circom";
include "MerkleTree.circom";
include "withdraw.circom";

template testWithdrwal(levels) {
    signal input nullifiers[2**levels];
    signal input secrets[2**levels];
    signal output commitment[2**levels];
    signal output nullifierHash[2**levels];

    component commitmentHasher[2**levels];
    component mt = MerkleTree(levels);

    for (var i = 0; i < 2**levels; i++){
        commitmentHasher[i] = CommitmentHasher();
        commitmentHasher[i].nullifier <== nullifiers[i];
        commitmentHasher[i].secret <== secrets[i];

        commitment[i] <== commitmentHasher[i].commitment;
        nullifierHash[i] <== commitmentHasher[i].nullifierHash;

        mt.leaves[i] <== commitmentHasher[i].commitment;
    }

    log("root: ", mt.root);

    component w = Withdraw(levels);

    w.nullifierHash <== nullifierHash[1];
    w.root <== mt.root;
    w.commitmentHash <== commitment[1];
    w.nullifier <== nullifiers[1];
    w.secret <== secrets[1];
    w.pathIndices[0] <== 1;
    w.pathIndices[1] <== 0;
    w.pathElements[0] <== commitment[0];
    w.pathElements[1] <== 16578468044277875313671329034581045556852724212077950999681567137220394371464;

}

component main {public [nullifiers]} = generateTree(2);

/* INPUT = {
    "nullifiers": [1,2,3,4],
    "secrets": [100,200,300,400]
} */
