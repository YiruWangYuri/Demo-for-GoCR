
%   run me for compiling necessary .cpp/.c files  

% priority queue
cd ./src/PriorityQueue;
mex -I./class_interface/class_interface priority_queue_interface_mex.cpp
cd ../../

% priority queue
cd ./src/utlis/UN_bmvc/D+1;
mex getChild.c
cd ../../../../
