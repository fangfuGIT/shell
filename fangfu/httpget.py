# -*- coding: utf-8 -*-
import requests


def get_data_by_get(query):
    r = requests.get("http://localhost:4242/api/query?" + query)
    if len(r.json()) > 0:
        dps = r.json()[0]['dps']
        return dps
    else:
        return None


if __name__ == "__main__":
    print get_data_by_get('start=1578585600000&m=sum:sig')
