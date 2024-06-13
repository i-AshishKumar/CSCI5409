from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import mysql.connector
from typing import List

app = FastAPI()

mydb = mysql.connector.connect(
    host="cloud-a2-db.c2vshgpyt6vg.us-east-1.rds.amazonaws.com",
    user="admin",
    password="password",
    database="clouddb"
)

class Product(BaseModel):
    name: str
    price: str
    availability: bool

class ProductList(BaseModel):
    products: List[Product]

@app.post("/store-products")
async def store_products(request: ProductList):
    try:
        cursor = mydb.cursor()
        val = []

        for product in request.products:
            val.append((product.name, product.price, product.availability))

        cursor.executemany("INSERT INTO products (name, price, availability) VALUES (%s, %s, %s)", val)
        mydb.commit()
        cursor.close()
        return {"message": "Success."}
    except Exception as e:
        raise HTTPException(status_code=400, detail="Insertion failed. Something went wrong!")

@app.get("/list-products")
async def list_products():
    try:
        cursor = mydb.cursor()
        cursor.execute("SELECT * FROM products")
        products = cursor.fetchall()

        response = {"products": []}

        for product in products:
            temp = {"name": product[0], "price": product[1], "availability": bool(product[2])}
            response["products"].append(temp)

        cursor.close()
        return response
    except Exception as e:
        raise HTTPException(status_code=400, detail="Listing failed. Something went wrong!")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
