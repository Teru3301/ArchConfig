#!/bin/bash

load=$(prime-run nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)

if [[ $? -ne 0 || -z "$load" ]]; then
  echo "N/A"
else
  echo "${load}"
fi

