import time
import math
import requests

def get_value(num):
    return math.sin(num)+1


def send_json(json, s):
    r = s.post("http://localhost:4242/api/put?details", json=json)
    return r.text


def main():
    s = requests.Session()
    a = int(time.time()) - 100
    ls = []
    tsuids = 000001000002000001
    for i in range(1, 100):
        json = {
            "metric": "sys.batch.sig",
            "timestamp": a,
            "tsuids": tsuids,
            "value": get_value(i),
            "tags": {
                "host": "web01",
                "dc": "lga"
            }
        }
        i += 0.01
        a += 1
        tsuids += 1
        ls.append(json)
        if len(ls) == 50:
            send_json(ls, s)
            ls = []
    send_json(ls, s)
    ls = []


if __name__ == "__main__":
    start = time.time()
    main()
    print time.time()-start
