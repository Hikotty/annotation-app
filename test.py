import requests

url = 'http://127.0.0.1:8080/start_action'
data = {'action': 'treel'}
response = requests.post(url, json=data)
print(response)