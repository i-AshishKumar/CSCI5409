import boto3
import json

s3 = boto3.client("s3")
rekognition = boto3.client("rekognition", region_name="us-east-1")
dynamodb = boto3.resource("dynamodb")
tableName = "users"
usersTable = dynamodb.Table(tableName)
bucketName = "visitor-faces-cloud-term-2024"

def lambda_handler(event, context):
    # print("Received event:", json.dumps(event, indent=2))
    try:
        objectKey = event['queryStringParameters']['objectKey']
        print(f"Object key: {objectKey}")
        
        image_object = s3.get_object(Bucket=bucketName, Key=objectKey)
        image_bytes = image_object['Body'].read()
        print(f"Retrieved image bytes: {len(image_bytes)} bytes")
        
        response = rekognition.search_faces_by_image(
            CollectionId='users',
            Image={'Bytes': image_bytes}
        )
        print("Rekognition response:", json.dumps(response, indent=2))
        
        for match in response['FaceMatches']:
            print(f"Match found: FaceId={match['Face']['FaceId']}, Confidence={match['Face']['Confidence']}")

            face = usersTable.get_item(
                Key={
                    'rekognitionId': match['Face']['FaceId']
                }
            )
            if 'Item' in face:
                print("marker1")
                print("Person found:", json.dumps(face['Item'], indent=2))
                print("marker2")
                return buildResponse(200, {
                    'Message': 'Success',
                    'rekognitionId': face['Item']['rekognitionId'],
                    'firstName': face['Item']['firstName'],
                    'lastName': face['Item']['lastName']
                })
        
        print("Person could not be recognized")
        return buildResponse(403, {'Message': 'Person Not Found'})
    
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return buildResponse(500, {'Message': 'Internal Server Error', 'Error': str(e)})

def buildResponse(statusCode, body=None):
    response = {
        'statusCode': statusCode,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
    if body is not None:
        response['body'] = json.dumps(body)
    return response
