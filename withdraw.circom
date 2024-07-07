pragma circom  2.0.0;

include "MerkleTreeChecker.circom";
include "commitmentHasher.circom";


// Verifies that commitment that corresponds to given secret and nullifier is included in the merkle tree of deposits
template Withdraw(levels) {
    signal input nullifierHash;
    signal input root;
    signal input commitmentHash;
    signal input nullifier;
    signal input secret;
    signal input pathElements[levels];
    signal input pathIndices[levels];

    component hasher = CommitmentHasher();

    hasher.nullifier <== nullifier;
    hasher.secret <== secret;
    hasher.nullifierHash === nullifierHash;

    component tree = merkleTreeChecker(levels);
    tree.leaf <== hasher.commitment;
    tree.root <== root;

    for (var i = 0; i < levels; i++){
        tree.pathElements[i] <== pathElements[i];
        tree.pathIndices[i]  <== pathIndices[i];
     }

}