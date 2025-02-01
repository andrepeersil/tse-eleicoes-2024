#%%
import sqlalchemy
import pandas as pd
import os
#%%

current_dir = os.path.dirname(__file__)
file_path = os.path.join(current_dir, 'query_categorias.sql')
#%%
with open(file_path, 'r', encoding='utf-8') as open_file:
    query = open_file.read()

engine = sqlalchemy.create_engine('sqlite:///../data/database.db')
df = pd.read_sql_query(query, engine)
#%%
df.shape
#%%

df.to_csv('../data/query_categorias.csv')
df.to_parquet('../data/query_categorias.parquet')
file_size_csv = os.path.getsize('../data/query_categorias.csv')
file_size_parquet = os.path.getsize('../data/query_categorias.parquet')
#%%

print(f"file size csv: {file_size_csv}")
print(f"file size parquet: {file_size_parquet}")


