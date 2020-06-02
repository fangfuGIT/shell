# -*- coding: utf-8 -*-
import requests


def get_data_by_get(query):
    r = requests.get("http://localhost:4242/api/query/last?" + query)
#    r = requests.get("http://localhost:4242/api/query?" + query)
    if len(r.json()) > 0:
        dps = r.json()[0]['dps']
        return dps
    else:
        return None

def get_data_by_get_last(query):
    r = requests.get("http://localhost:4242/api/query/last?" + query)
    dps = r.json()
    return dps


if __name__ == "__main__":
#    print get_data_by_get('start=1573193417&m=sum:sys.batch.sig')
#    print get_data_by_get('tsuids=000001000002000001&backScan=24&resolve=true')
#    print get_data_by_get_last('tsuids=000001000002000001&timeseries=sys.batch.sig&backScan=240000000000&resolve=true')

#    print get_data_by_get_last('tsuids=000001000002000001&backScan=240000000000&resolve=true')

#http://localhost:4242/api/query/last?tsuids=000001000002000001&timeseries=sys.batch.sig&backScan=240000000000&resolve=true

    xx=requests.get("http://localhost:4242/api/query/last?tsuids=000001000002000001&backScan=24&resolve=true")
    print xx.status_code
    print type(xx)
    print xx.text
