import { predictPredictPost } from "./client/sdk.gen";

const file = Bun.file("./test-image.jpeg");

const { data, error } = await predictPredictPost({
  body: {
    input: new Blob([await file.arrayBuffer()]),
  },
  baseUrl: "http://localhost:8000",
});

if (error) {
  console.error("Error:", error);
  throw new Error("Prediction failed");
}

console.log(data);
