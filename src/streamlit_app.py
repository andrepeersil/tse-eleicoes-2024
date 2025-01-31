import pandas as pd
import os
import streamlit as st
import matplotlib.pyplot as plt
import seaborn as sns
from adjustText import adjust_text
from sklearn.cluster import KMeans
 

app_path = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.dirname(app_path)
base_path = os.path.dirname(src_path)
data_path = os.path.join(src_path, "data")

filmename = os.path.join(data_path, 'query_categorias.parquet')

@st.cache_data(ttl=60*60*24)
def carregar_dados():
    df = pd.read_parquet(filmename)
    return df

df = carregar_dados()

ufs = df[['SG_UF']].drop_duplicates()
cargos = df[['DS_OCUPACAO']].drop_duplicates()

st.title('TSE Analytics')

def about():

    st.markdown('''Esse repósitório visa estudar 
                algumas ferramentas de análise de 
                dados se utilziando dos dados abertos dos 
                candidatos das eleições de 2024. 
                ''')

    st.markdown('[Dados Abertos TSE](https://dadosabertos.tse.jus.br/dataset/candidatos-2024)')
    st.markdown('[Repositório GitHub](https://github.com/andrepeersil/tse-eleicoes-2024)')


with st.sidebar:
    uf = st.selectbox(
        "Escolha um estado:",
        (ufs),
    )

with st.sidebar:
    cargo = st.selectbox(
        "Escolha um cargo:",
        (cargos),
    )

with st.sidebar:
    bolhas = st.checkbox("Ativar Bolhas(Total Candidatos")

with st.sidebar:
    cluster = st.checkbox("Ativar Clusterização")

with st.sidebar:
    n_clusters = st.slider("Quantos clusters?", 1, 8)

with st.sidebar:
    about()

df_select = df[df['SG_UF']==uf and df['DS_OCUPACAO']==cargo]

ymedio = df_select['txPretos'].mean()
xmedio = df_select['txfem'].mean()

ymin = df_select['txPretos'].min()
xmin = df_select['txfem'].min()

ymax = df_select['txPretos'].max()
xmax = df_select['txfem'].max()

fig = plt.figure(figsize=(6, 6),dpi=100)

if bolhas:
    bolhas = 'totalcandidatos'

if cluster:
    X = df_select[['txfem', 'txPretos']]
    kmeans = KMeans(n_clusters=n_clusters, random_state=0, n_init="auto")
    kmeans.fit(X)
    cluster = kmeans.labels_
    
else:
    cluster = None

sns.scatterplot(
    data=df_select, 
    x='txfem', 
    y='txPretos',
    
    size=bolhas,
    alpha = .5,

    legend=False,
    sizes=(20, 200),

    hue = cluster,
    palette = 'Set2',

    )

nomes_partidos = df_select['SG_PARTIDO'].to_list()

x = df_select['txfem'].to_list()
y = df_select['txPretos'].to_list()

texts = [plt.text(x[i], y[i], nomes_partidos[i], fontsize=10) for i in range(len(x))]
adjust_text(texts,
        arrowprops=dict(arrowstyle='->', color='red',alpha=.5)
        );

plt.suptitle("Candidaturas de Mulheres x Candidaturas de Pessoas Pretas", fontsize=14) 
plt.title(f"Eleições Municipais - 2024 - {uf}", fontsize=12)  

plt.xlabel("Candidaturas de Mulheres", fontsize=10) 
plt.ylabel("Candidaturas de Pessoas Pretas", fontsize=10) 

plt.hlines(y=ymedio,xmin=xmin, xmax=xmax, linestyles='--', colors='green', label=f"Média Pessoas Pretas: {round(100*ymedio,1)}%")
plt.vlines(x=xmedio, ymin=ymin, ymax=ymax, linestyles='--', colors='orange',label=  f"Média Mulheres: {round(100* xmedio,1)}%")

plt.legend(loc="upper center", bbox_to_anchor=(0.5, -0.15)) 

plt.grid(True)

st.pyplot(fig=fig)
