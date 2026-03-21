import paho.mqtt.client as mqtt
import csv
from datetime import datetime
import time

# CSV文件设置
CSV_FILE = "mqtt_data.csv"

# MQTT回调函数
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {str(rc)}")
    client.subscribe("your/topic")  # 订阅主题

def on_message(client, userdata, msg):
    print(f"Received message on {msg.topic}: {msg.payload.decode()}")
    
    # 写入CSV文件
    with open(CSV_FILE, 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([
            datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            msg.topic,
            msg.payload.decode()
        ])

# 初始化CSV文件
def init_csv():
    with open(CSV_FILE, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Timestamp", "Topic", "Message"])

# 主函数
def main():
    init_csv()  # 初始化CSV文件
    
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message
    
    try:
        client.connect("broker.hivemq.com", 1883, 60)
        client.loop_forever()
    except KeyboardInterrupt:
        print("Disconnecting...")
        client.disconnect()

if __name__ == "__main__":
    main()