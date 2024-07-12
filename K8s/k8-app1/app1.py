from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import requests
import os

app = FastAPI()

class InputData(BaseModel):
    file: Optional[str]  # Optional file name because file name can be None/null
    product: str


@app.post("/calculate")
async def calculate(data: InputData):
    file_name = data.file
    product = data.product
    
    file_path = f"/Ashish_PV_dir/{file_name}"

    # TEST 1: Null Check
    # Check if the file name is None and return an error if it is
    if file_name == None:
        return {"file": None, "error": "Invalid JSON input."}

    # TEST 2: File not found
    # Check if the file does not exist at the specified path and return an error if it doesn't
    if not os.path.exists(file_path):
        return {"file": file_name, "error": "File not found."}

    # Sending a POST request to another container's endpoint to perform the sum calculation
    response = requests.post("http://app2-service/sum", json={"file": file_name, "product": product})
    return response.json()

class InputDataFile(BaseModel):
    file: Optional[str] = None
    data: Optional[str] = None
    product: Optional[str] = None

@app.post("/store-file")
async def store_file(idata: InputDataFile):
    file_name = idata.file
    data = idata.data

    # 1. Validate input JSON to ensure file name was provided
    if file_name == None:
        return {"file": None,"error": "Invalid JSON input."}
    # 2. Store the file.
    try:
        with open("/Ashish_PV_dir/" + file_name, "w+") as csvfile:
            csvfile.write(data.replace(" ", ""))

    except Exception as e:
        # 2.1 Send error response if there was exception.
        return {"file": None,"error": "Error while storing the file to the storage."}
    
    # 2.2 Send success response if there was no exception during creating/storing the file.
    return {"file": file_name,"message": "Success."} 

