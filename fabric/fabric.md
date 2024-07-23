# Creating AWS MC Fabric server  
These are the steps and config options for creating a Minecraft Fabric server  

## AWS EC2 Configs  
* Instance type: t3a.medium  

## AWS Lambda Configs  
Configurations for Lambda functions to start/stop the server with a URL  

### Start Function  
Code (Python):  
```
import boto3
import json
region = 'us-east-1'
instances = ['i-072ea57bea1d9fb8a']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
    message = {
        'message': 'Server is starting, wait about 2 minutes...'
    }
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(message)
    }
```

* Change `region` with the correct EC2 instance region  
* Change `instances` with the correct EC2 instance ID  

Trigger(s):  
* API Gateway  
* When the gateway receives an HTTP request it should trigger the Lambda function  

### Stop Function  
Code (Python):  
```
import boto3
region = 'us-east-1'
instances = ['i-072ea57bea1d9fb8a']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
    return { 
        'message' : 'ec2 instance STOP has been initiated...'
    }
```

* Change `region` with the correct EC2 instance region  
* Change `instances` with the correct EC2 instance ID  

Trigger(s):  
* API Gateway  
* When the gateway receives an HTTP request it should trigger the Lambda function  

## AWS CloudWatch configs  
Use AWS Cloudwatch to auto-shutdown server when there's no activity  

Steps:  
* Create alarm  
* Metric:  
    1. Metric name: NetworkIn  
    2. Instance ID: EC2 Instance  
    3. Statistic: Average  
    4. Period: 1 hour  
* Conditions:  
    1. Threshold type: Static  
    2. Whenever NetworkIn is: Lower/Equal  
    3. than...: 10000 (ten thousand)  
* EC2 action:  
    1. Alarm state trigger: In alarm  
    2. Take the following action: Stop this instance  

## To Do  
* Write .sh script that automatically backs up world  

