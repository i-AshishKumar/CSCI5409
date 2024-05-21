from fastapi import FastAPI
from pydantic import BaseModel
import csv

app = FastAPI()

class InputData(BaseModel):
    file: str | None
    product: str

@app.post("/sum")
async def sum_product(data: InputData):
    file_name = data.file
    product = data.product

    file_path = f"/shared_volume/{file_name}"

    # if file_name.split()[-1] != "csv":
    #     return {"error": "Input file not in CSV format.","file": file_name}
    # else:
    #     with open(file_path, newline='') as csvfile:
    #         reader = csv.DictReader(csvfile)
    #         total = sum(int(row['amount']) for row in reader if row['product'] == product)
    #     return {"file": file_name, "sum": total}


    try:
        with open(file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            total = sum(int(row['amount']) for row in reader if row['product'] == product)
        return {"file": file_name, "sum": total}
    except (csv.Error, IOError, StopIteration):
        return {"error": "Input file not in CSV format.","file": file_name}
    
    
