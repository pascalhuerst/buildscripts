#!/bin/bash
LIST=""; for file in `cat dependencies.txt`; do LIST+="${file} " ; done; echo $LIST;
