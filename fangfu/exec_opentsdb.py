import requests

payload = {
    "metric": "sys.nice",
    "timestamp": '1577085305',
    "value": '29',
    "tags": {
        "host": "web01",
        "dc": "lga"
    }
}

payload1 = {
    "metric": "sys.nice",
    "timestamp": '1577085306',
    "value": '30',
    "tags": {
        "host": "web01",
        "dc": "lga"
    }
}

payload2 = {
    "metric": "sys.nice",
    "timestamp": '1577085307',
    "value": '29',
    "tags": {
        "host": "web01",
        "dc": "lga"
    }
}

payload3 = {
    "metric": "sys.nice",
    "timestamp": '1577085308',
    "value": '30',
    "tags": {
        "host": "web01",
        "dc": "lga"
    }
}
payload4 = {
    "metric":"pointSync",
    "tags": { 
        "receiverId":"1",
        "messageId":"5825e7ecacf9459888e2dd5be4167e19-1573539179037",
        "time":"1573539179036",
        "source":"android",
        "type":"2",
        "userId":"0",
        "contentType":"1",
        "content":"weqsfhwiurwrbo"
#        "content":"weqsfhwiu rwrb cnwqbyecinwuebcweubcwebtcbiwcwquwebcqwy qbweyciuwbeciuwqbcabgnwcbnwetbdcgnweweiugfiyusegyfwopegrhouegfewfweuwirecniebrywnieugfehufuheuisgfeiyugfyuwgicnr8 cywefgnciugfy 63487t23rgcnwg 9ywgacer cwiur cbiwbfneybi72t7tcqnwbgcbigny8oyrcnigr89bncyr wncisa wegcbw97enw8wcinwwiurncbq8wbyw8r3286c87 wrcntwgqe7cixt34687r8ewcgqwe7cy8wbdnwuyd87wcysrnwe7rywb8cnqr8ef wcr7w rcibbefcrifuwbeyncriywesbxniqwyecinexaylnciaxwicanawisewaawiurncbwe7brcynwbityarbcnw7siabfnwcnriywnesicybwnsicynicxyalnwdmcniwesfncsxeinocniunsdioxsfsuzknciucnesiaycbnsisfybncsniewsnfcusficfnsufkhesinfchks nisxhnciuehsi focnwieciescnsicnoasowcswoesiweynrcisecseifcfnxewascwsfnscigf cngis efucnisnfbywecbe68rtbw387rctw3478cnortw9rowcnxwynxr7cq90ncbq cnwe9ry7cn3rcybw9nryc839rcnbw9nterwc87nwoabn3wcbwe87rtcx3wrt7eenw8cnrwc9w87nbetwrc87wercaewqrcnwyne7wbcrnewscre fyneoscgsrfe coinseso necoesly7easrcbs78eftefy8w7groaeygfewo7f8ewoewwerynwevyr9sy8rewvjeoncy8ewy7rng8ersnyfcaweyorefcd8esnvoe8salvcesfovcefs"
    },
    "value" : 0,
    "timestamp" : 1577085320
}
#ls = [payload, payload1, payload2, payload3]
ls = [payload4]
def send_json(json):
    r = requests.post("http://localhost:4242/api/put?details", json=json)
    return r.text


def main():
    print send_json(ls)


if __name__ == "__main__":
    main()



