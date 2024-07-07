pragma circom  2.0.0;

include "../circomlib/circuits/mimcsponge.circom";
include "MerkleTree.circom";


template merkleProofChecker(levels) {
    signal input leaf;
    signal input root;
    signal input leafIndex;
    signal input pathElements[levels];
   
   signal proofIndex[levels];

    var i = 0;
    component hashers[levels];
    var index;

    for (i = 0; i < levels; i++){
        log("level ", i);
        hashers[i] = HashLeftRight();
        
        index = i == 0 ? leafIndex : index \ 2;

        log("Index: ", proofIndex[i]);

        if (index % 2 == 0){
            hashers[i].left <== i == 0 ? leaf : hashers[i-1].hash;
            hashers[i].right <== pathElements[i];
         }
         else {
            hashers[i].left <== pathElements[i];
            hashers[i].right <== i == 0 ? leaf : hashers[i-1].hash;
         }
        
        log("left: ", hashers[i].left);
        log("right: ", hashers[i].right);
        log("hash: ", hashers[i].hash);
    }
    log("root: ", root);
    log("i: ", i);
    log("Calculated root: ", hashers[i-1].hash);

    root === hashers[i-1].hash;

    
}


// bool leaf_existence(int root, vector<int>& proof, int leaf, int leaf_index) {
//     int len = proof.size();
//     vector<int> hashes;

//     int level = 0;
//     int level_proof_index = leaf_index;
//     int h = leaf;
//     while(level < len){
//             if (level_proof_index % 2 == 0)
//             {
//                  h = Hash(h, proof[level]);
               
//             }
//             else{
//                 int h = Hash(proof[level], h);
//              }
        
//            level_proof_index = level_proof_index / 2;
//            level++;
//         }
//         return (root == hashes[level]);
//     }
