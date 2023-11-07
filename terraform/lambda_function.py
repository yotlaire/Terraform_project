import json

def lambda_handler(event, context):
    # Retrieve the S3 bucket and object information from the event
    s3_event = event['Records'][0]['s3']
    bucket_name = s3_event['bucket']['name']
    object_key = s3_event['object']['key']

    # Perform actions on the uploaded image, e.g., generate thumbnails, process, etc.
    # Replace this section with your actual image processing logic

    return {
        'statusCode': 200,
        'body': json.dumps('Image processing complete!')
    }
