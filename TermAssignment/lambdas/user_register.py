import boto3

s3 = boto3.client("s3")
rekognition = boto3.client("rekognition", region_name="us-east-1")
dynamodb = boto3.resource("dynamodb")
tableName = "users"
usersTable = dynamodb.Table(tableName)

def lambda_handler(event, context):
    print(event)
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]

    try:
        response = index_user_image(bucket,key)
        print(response)
        if response['ResponseMetadata']['HTTPStatusCode']==200:
            faceId = response['FaceRecords'][0]['Face']['FaceId']
            name = key.split('.')[0].split('_')
            print(name)
            firstName = name[0]
            lastName = name[1]
            register_user(faceId, firstName, lastName)
        return response
    except Exception as e:
        print(e)

def index_user_image(bucket, key):
    response = rekognition.index_faces(
        Image={
            'S3Object':
            {
                'Bucket':bucket,
                'Name':key
            }
        },
        CollectionId="users"
    )

    return response
    


def register_user(faceId, firstName, lastName):
    usersTable.put_item(
        Item={
            'rekognitionId':faceId,
            'firstName':firstName,
            'lastName':lastName
        }
    )
    