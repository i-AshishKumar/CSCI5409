import csv

try:
    with open("test.yml", newline='') as csvfile:
        csv_reader = csv.reader(csvfile, delimiter=',')
        for row in csv_reader:
            print(row)
except Exception as e:
        r = {"file": "test.csv", "error": "Input file not in CSV format."}
        print(r)