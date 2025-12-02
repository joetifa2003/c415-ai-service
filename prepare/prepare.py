import os
import csv

root_dir = "../data"
output_csv = "dataset.csv"


def generate_csv(root_dir, output_file):
    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["image_path", "label"])

        for subdir, _, files in os.walk(root_dir):
            for file in files:
                if file.lower().endswith(".jpg") or file.lower().endswith(".jpeg"):
                    full_path = os.path.join(subdir, file)
                    category = os.path.basename(subdir)
                    writer.writerow([full_path, prepare_category(category)])
    print(f"Successfully created {output_file} with image paths and labels.")


def prepare_category(category: str) -> str:
    return category.lower()


if __name__ == "__main__":
    if os.path.exists(root_dir):
        generate_csv(root_dir, output_csv)
    else:
        print(f"Error: The directory '{root_dir}' was not found.")
