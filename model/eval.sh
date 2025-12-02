#!/bin/bash

uv run ludwig evaluate --model_path results/prod/model --dataset ../prepare/dataset.csv --split test --output_directory results/prod
