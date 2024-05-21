from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import csv

app = FastAPI()

class InputData(BaseModel):
    file: str
    product: str

@app.post("/sum")
async def sum_product(data: InputData):
    file_name = data.file
    product = data.product

    file_path = f"/shared_volume/{file_name}"

    try:
        with open(file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            total = sum(int(row['amount']) for row in reader if row['product'] == product)
        return {"file": file_name, "sum": total}
    except Exception as e:
        return {"error": "Input file not in CSV format.","file": file_name, }
