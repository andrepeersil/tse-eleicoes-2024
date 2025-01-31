with tb_cargos as (
    select distinct DS_OCUPACAO,
    count(*)
    from tb_candidaturas
    group by 1
    order by 2 desc
    ),

tb_todos_cargos as (
    select 'TODOS' as DS_OCUPACAO,
    count(*)
    from tb_candidaturas
)
