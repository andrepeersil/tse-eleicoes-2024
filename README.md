# Análise dos Dados Abetos TSE 
## Eleições Municipais 2024

Esse repósitório visa estudar algumas ferramentas de análise de dados se utilziando dos dados abertos dos candidatos das eleições de 2024.

Fonte dos dados: [Dados Abertos TSE](https://dadosabertos.tse.jus.br/dataset/candidatos-2024

)

Aqui utilizo:
SQL (Sqlite)
Python (Pandas, Matplolib,Seaboarn SqlAlchemy)



Inicialmente realizamos a ingestão dos dados, que são organizados em tabelas SQL e algumas dados são selecionados, principalmente dados relacionados a diversidade dos partidos em cada estado brasileiro.

Após isso a criação de um gráfico que mostra a distribuição das taxas de candidaturas de mulheres e de candidaturas de pessoas pretas a nível Brasil, de cada partido, também trazendo a média nacional dessas taxas.

O tamanho da bolha representa a escala das quantidades de candidaturas do partido a nível nacional.


<img alt="<alt-text>" src="<https://raw.githubusercontent.com/andrepeersil/tse-eleicoes-2024/refs/heads/main/img/grafico_mulherxpretos_v2.png>" />