from fastapi import FastAPI, UploadFile, File
from ludwig.api import LudwigModel
import pandas as pd
import numpy as np
from PIL import Image
import io
from pydantic import BaseModel

app = FastAPI()

print("Loading model...")
model = LudwigModel.load("./model/results/prod/model")
print("Model loaded.")


class PredictOutput(BaseModel):
    label: str
    probability_blight: float
    probability_common_rust: float
    probability_gray_leaf_spot: float
    probability_healthy: float


@app.post("/predict")
async def predict(input: UploadFile = File(...)) -> PredictOutput:
    image_bytes = await input.read()
    image = Image.open(io.BytesIO(image_bytes))
    image_array = np.array(image.convert("RGB"))
    data = {"image_path": [image_array]}
    df = pd.DataFrame(data)

    predictions, _ = model.predict(
        df, skip_save_predictions=True, skip_save_progress=True
    )

    data = {
        "label": predictions["label_predictions"][0],
        "probability_blight": predictions["label_probabilities_blight"],
        "probability_common_rust": predictions["label_probabilities_common_rust"],
        "probability_gray_leaf_spot": predictions["label_probabilities_gray_leaf_spot"],
        "probability_healthy": predictions["label_probabilities_healthy"],
    }

    return PredictOutput(**data)
