#%%
import chardet

#%%


with open('queries.sql', 'rb') as file:
    raw_data = file.read()
    result = chardet.detect(raw_data)
    encoding = result['encoding']
    print(f"Codificação detectada: {encoding}")

with open('queries.sql', 'r', encoding=encoding) as open_file:
    query = open_file.read()
