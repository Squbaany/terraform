import json
import math
import os
import boto3

# Stałe Steinhart-Harta 
A = 1.40e-3
B = 2.37e-4
C = 9.90e-8

SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')

sns_client = boto3.client('sns')

def calculate_temperature(R):
    if R <= 0:
        return None
    try:
        log_R = math.log(R)
        temp_k = 1.0 / (A + B * log_R + C * (log_R**3))
        temp_c = temp_k - 273.15
        return temp_c
    except ValueError:
        return None

def lambda_handler(event, context):
    sensor_id = event.get("sensor_id")
    value_R = event.get("value") # Rezystancja

    if not all([sensor_id, isinstance(value_R, (int, float))]):
        return {"error": "INVALID_INPUT", "sensor_id": sensor_id}

    if not (1 <= value_R <= 20000):
        return {"error": "VALUE_OUT_OF_RANGE", "sensor_id": sensor_id, "value_R": value_R}

    temperature = calculate_temperature(value_R)
    if temperature is None:
        return {"error": "CALCULATION_ERROR", "sensor_id": sensor_id, "value_R": value_R}

    status = ""
    if temperature < 20:
        status = "TEMPERATURE_TOO_LOW"
    elif temperature < 100:
        status = "OK"
    elif temperature < 250:
        status = "TEMPERATURE_TOO_HIGH"
    else:
        status = "TEMPERATURE_CRITICAL"
        if SNS_TOPIC_ARN:
            try:
                message = f"Critical temperature event for sensor {sensor_id}! Temperature: {temperature:.2f}°C. Resistance: {value_R} Ohm."
                sns_client.publish(
                    TopicArn=SNS_TOPIC_ARN,
                    Message=message,
                    Subject=f"Alert: Critical Temperature Sensor {sensor_id}"
                )
            except Exception as e:
                print(f"Error sending SNS notification: {e}")
    
    return {
        "sensor_id": sensor_id,
        "resistance_ohm": value_R,
        "temperature_celsius": round(temperature, 2),
        "status": status
    }
