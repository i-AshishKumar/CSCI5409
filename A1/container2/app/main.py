from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import csv

app = FastAPI()

class InputData(BaseModel):
    file: Optional[str] 
    product: str

@app.post("/sum")
async def sum_product(data: InputData):
    file_name = data.file
    product = data.product

    file_path = f"/shared_volume/{file_name}"

    try:
        with open(file_path, newline='') as csvfile:
            csv_reader = csv.reader(csvfile, delimiter=',')
            for row in csv_reader:
                if len(row) != 2:
                    return { "file": file_name, "error": "Input file not in CSV format.", "row":row}
                if(row[0] == product):
                    sum = sum + int(row[1])

        return { "file": file_name, "sum": sum}
    except Exception as e:
        return {"file": file_name, "error": "Input file not in CSV format."}
