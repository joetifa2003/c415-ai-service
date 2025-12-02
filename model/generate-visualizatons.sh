#!/bin/bash
set -ex

MODEL=results/prod
OUTPUT_DIR=visualizations/

TEST_STATS=$MODEL/test_statistics.json
TRAIN_STATS=$MODEL/training_statistics.json
TRAIN_META=$MODEL/model/training_set_metadata.json
# ---------------------

if [ ! -f "$TEST_STATS" ]; then
    echo "Error: $TEST_STATS not found. Run 'ludwig evaluate' first."
    exit 1
fi

if [ ! -f "$TRAIN_STATS" ]; then
    echo "Error: $TRAIN_STATS not found."
    exit 1
fi

echo "Generating visualizations in $OUTPUT_DIR..."

echo "1. Generating Frequency vs F1..."
uv run ludwig visualize --visualization frequency_vs_f1 \
  --test_statistics $TEST_STATS \
  --ground_truth_metadata $TRAIN_META \
  --output_feature_name label \
  --output_directory $OUTPUT_DIR \
  -ff png

echo "2. Generating Learning Curves..."
uv run ludwig visualize --visualization learning_curves \
  --training_statistics $TRAIN_STATS \
  --output_directory $OUTPUT_DIR \
  -ff png

echo "3. Generating Confusion Matrix..."
uv run ludwig visualize --visualization confusion_matrix \
  --test_statistics $TEST_STATS \
  --ground_truth_metadata $TRAIN_META \
  --output_directory $OUTPUT_DIR \
  -ff png

echo "Done! Check the '$OUTPUT_DIR' folder."
