import boto3
from datetime import datetime

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Obtiene el ID de la instancia de EC2 que deseas iniciar o detener
    instance_id = '' # Example i-051bxasfas51ee2a7

    # Obtiene la hora actual
    current_time = datetime.now()
    
    # Imprime la hora actual
    print(f'current_time: {current_time}')
    print(f'hour: {current_time.hour}')
    
    # Hora en encender y apagar
    if current_time.hour == 11:
        # Inicia la instancia de EC2
        ec2.start_instances(InstanceIds=[instance_id])
        print(f'Start instance')
    elif current_time.hour == 23:
        # Detiene la instancia de EC2
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f'Stop instance')