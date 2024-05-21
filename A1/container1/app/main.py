from fastapi import FastAPI
from pydantic import BaseModel
import requests
import os

app = FastAPI()

class InputData(BaseModel):
    file: str | None
    product: str

@app.post("/calculate")
async def calculate(data: InputData):
    file_name = data.file
    product = data.product
    
    file_path = f"/shared_volume/{file_name}"

    if file_name == None:
        return {"error": "Invalid JSON input.", "file": None,}

    if not os.path.exists(file_path):
        return {"file": file_name, "error": "File not found."}

    
    response = requests.post("http://container2:7000/sum", json={"file": file_name, "product": product})
    return response.json()
