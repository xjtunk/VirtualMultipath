# VirtualMultipath
CoNEXT '18 Artifacts

Paper #32: Boosting fine-grained activity sensing by embracing wireless multipath effects

This repository contains algorithms for enhance fine-grained activity sensing using “virtual” multipath. The fine-grained activities include human respiration monitoring, finger gesture
recognition, chin movement tracking when speaking. We employ WARP platform to collect data. The original signal does not show obvious variations while the target performs each activity. After adding extra static multipath, we can change the sensing signal with good sensing capability. 

# Dataset Description

The data locate in the directory /data/.

1. respiration.mat is the human respiration Wi-Fi signal for 1 minute. 
2. finger1.mat is the Wi-Fi signal for finger gesture *'up'*
3. finger2.mat is the Wi-Fi signal for finger gesture *'no'*
4. chin.mat is the Wi-Fi signal for chin movement when speaking *'how are you, I am fine.'*

# Running the tests

To run the code, you only need to change the variable *fname* to the corresponding dataset name, then run the *main* function.
