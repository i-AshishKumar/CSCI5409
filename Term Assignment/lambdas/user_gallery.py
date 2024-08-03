import json
import boto3
import base64

s3 = boto3.client('s3')
S3_BUCKET = 'user-galleries-cloud-term-2024'

def lambda_handler(event, context):
    # print(event)
    try:
        print("pre-marker")
        print(event['body'])
        body = event['body']
        
        if 'action' in body and body['action'] == 'list':
            user_id = body['rekognitionId']
            user_folder = f"{user_id}/"
            response = s3.list_objects_v2(Bucket=S3_BUCKET, Prefix=user_folder)
            files = [item['Key'] for item in response.get('Contents', [])]
            
            file_details = []
            for file in files:
                file_name = file.split('/')[-1]
                url = s3.generate_presigned_url(
                    ClientMethod='get_object',
                    Params={'Bucket': S3_BUCKET, 'Key': file},
                    ExpiresIn=3600  # URL expiration time in seconds (e.g., 1 hour)
                )
                file_details.append({'fileName': file_name, 'fileUrl': url})
                
                
            return {
                'statusCode': 200,
                'body': json.dumps({'files': file_details})
            }
            
        elif 'action' in body and body['action'] == 'upload':
            print("marker2")
            # Existing upload code...
            user_id = body['rekognitionId']
            file_content = base64.b64decode(body['file'])
            file_name = body['fileName']
            
            user_folder = f"{user_id}/"
            object_key = f"{user_folder}{file_name}"
            
            s3.put_object(Bucket=S3_BUCKET, Key=object_key, Body=file_content)
            
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'File uploaded successfully', 'fileUrl': f'https://{S3_BUCKET}.s3.amazonaws.com/{object_key}'})
            }
        
        elif 'action' in body and body['action'] == 'delete':
            user_id = body['rekognitionId']
            file_name = body['fileName']
            
            user_folder = f"{user_id}/"
            object_key = f"{user_folder}{file_name}"
            
            s3.delete_object(Bucket=S3_BUCKET, Key=object_key)
            
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'File deleted successfully'})
            }
            
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error processing request', 'error': str(e)})
        }
