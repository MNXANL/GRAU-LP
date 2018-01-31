import unicodedata

def remove_accents(input_str):
    nfkd_form = unicodedata.normalize('NFKD', input_str)
    only_ascii = nfkd_form.encode('ascii', 'ignore')
    return only_ascii

print("asdásd")
print(remove_accents("asdásd").decode("ascii") )
print(type(remove_accents("asdásd").decode("ascii") ))