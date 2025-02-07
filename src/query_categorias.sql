
with tb_genero as (
    
    select SQ_CANDIDATO,
        SG_PARTIDO,
        DS_CARGO,
        SG_UF,
        case when DS_GENERO = 'MASCULINO' then 1 else 0 end as masc,
        case when DS_GENERO = 'FEMININO' then 1 else 0 end as fem

    from tb_candidaturas),

tb_cor_candidato as (
    select SQ_CANDIDATO,
    case when DS_COR_RACA = 'BRANCA' then 1 else 0 end as cor_BRANCA,
    case when DS_COR_RACA = 'PARDA' then 1 else 0 end as cor_PARDA,
    case when DS_COR_RACA = 'PRETA' then 1 else 0 end as cor_PRETA,
    case when DS_COR_RACA = 'NÃO INFORMADO' then 1 else 0 end as cor_NAO_INFORMADO,
    case when DS_COR_RACA = 'INDÍGENA' then 1 else 0 end as cor_INDÍGENA,
    case when DS_COR_RACA = 'AMARELA' then 1 else 0 end as cor_AMARELA,
    case when DS_COR_RACA = 'NÃO DIVULGÁVEL' then 1 else 0 end as cor_DIVULGAVEL

from tb_candidaturas
),


tb_cassados as (
    select SQ_CANDIDATO,
    1 as cassado

    from tb_cassacao
),


tb_educacao as (select SQ_CANDIDATO,
    case when DS_GRAU_INSTRUCAO = 'ENSINO MÉDIO COMPLETO' then 1 else 0 end as EDUC_MEDIO,
    case when DS_GRAU_INSTRUCAO = 'SUPERIOR COMPLETO' then 1 else 0 end as EDUC_SUPERIOR,
    case when DS_GRAU_INSTRUCAO = 'ENSINO FUNDAMENTAL COMPLETO' then 1 else 0 end as EDUC_FUNDAMENTAL

from tb_candidaturas
),


tb_estado_civil as (select SQ_CANDIDATO,
    case when DS_ESTADO_CIVIL = 'SOLTEIRO(A)' then 1 else 0 end as SOLTEIRO,
    case when DS_ESTADO_CIVIL = 'CASADO(A)' then 1 else 0 end as CASADO,
    case when DS_ESTADO_CIVIL = 'DIVORCIADO(A)' then 1 else 0 end as DIVORCIADO

from tb_candidaturas
),


tb_idades as (
    select SQ_CANDIDATO,
    2025 - cast(substr(DT_NASCIMENTO, -4) as  INT) as idade

    from tb_candidaturas
),


tb_merge as (
    select t1.SQ_CANDIDATO,
            t1.SG_PARTIDO,
            t1.DS_CARGO,
            t1.SG_UF,
            t1.masc,
            t1.fem,
            t2.cor_BRANCA,
            t2.cor_PARDA,
            t2.cor_PRETA,
            t2.cor_NAO_INFORMADO,
            t2.cor_INDÍGENA,
            t2.cor_AMARELA,
            t2.cor_DIVULGAVEL,
            coalesce(t3.cassado, 0) as cassado,
            t4.EDUC_MEDIO,
            t4.EDUC_SUPERIOR,
            t4.EDUC_FUNDAMENTAL,
            t5.SOLTEIRO,
            t5.CASADO,
            t5.DIVORCIADO,
            t6.idade


    from tb_genero as t1

    left join tb_cor_candidato as t2
    on t1.SQ_CANDIDATO = t2.SQ_CANDIDATO

    left join tb_cassados as t3
    on t1.SQ_CANDIDATO = t3.SQ_CANDIDATO

    left join tb_educacao as t4
    on t1.SQ_CANDIDATO = t4.SQ_CANDIDATO

    left join tb_estado_civil as t5
    on t1.SQ_CANDIDATO = t5.SQ_CANDIDATO

    left join tb_idades as t6
    on t1.SQ_CANDIDATO = t6.SQ_CANDIDATO

),

tb_taxas as (select SG_UF,
    SG_PARTIDO,
    DS_CARGO,

    count(SQ_CANDIDATO) as totalcandidatos,

    sum(masc) as totalmasc,
    sum(masc) / (1.0*count(SQ_CANDIDATO)) as txmasc,

    sum(fem) as totalfem,
    sum(fem) / (1.0*count(SQ_CANDIDATO)) as txfem,

    sum(cor_PRETA) as totalPRETA,
    sum(cor_PRETA) / (1.0* count(SQ_CANDIDATO)) as txPretos,

    sum(cor_PARDA) as totalPARDA,
    sum(cor_PARDA) / (1.0* count(SQ_CANDIDATO)) as txtPardos,

    sum(cor_BRANCA) as totalBRANCA,
    sum(cor_BRANCA) / (1.0* count(SQ_CANDIDATO)) as txBrancos,

    sum(cor_INDÍGENA) as totalINDÍGENA,
    sum(cor_INDÍGENA) / (1.0* count(SQ_CANDIDATO)) as txtIndigena,

    sum(cor_AMARELA) as totalAMARELA,
    sum(cor_AMARELA) / (1.0* count(SQ_CANDIDATO)) as txAmarelo,

    sum(cassado) as totalcassado,
    sum(cassado) / (1.0* count(SQ_CANDIDATO)) as txcassado,

    sum(EDUC_MEDIO) as totaEDUC_MEDIO,
    sum(EDUC_MEDIO) / (1.0* count(SQ_CANDIDATO)) as txEDUC_MEDIO,

    sum(EDUC_SUPERIOR) as totalEDUC_SUPERIOR,
    sum(EDUC_SUPERIOR) / (1.0* count(SQ_CANDIDATO)) as txEDUC_SUPERIOR,

    sum(EDUC_FUNDAMENTAL) as totalEDUC_FUNDAMENTAL,
    sum(EDUC_FUNDAMENTAL) / (1.0* count(SQ_CANDIDATO)) as txEDUC_FUNDAMENTAL,

    sum(SOLTEIRO) as totalSOLTEIRO,
    sum(SOLTEIRO) / (1.0* count(SQ_CANDIDATO)) as txSOLTEIRO,

    sum(CASADO) as totalCASADO,
    sum(CASADO) / (1.0* count(SQ_CANDIDATO)) as txCASADO,

    sum(DIVORCIADO) as totalDIVORCIADO,
    sum(DIVORCIADO) / (1.0* count(SQ_CANDIDATO)) as txDIVORCIADO,

    avg(idade) as med_idade

from tb_merge 
group by 1,2,3),

tb_taxas_br as (select 'Brasil' as SG_UF,
    SG_PARTIDO,
    DS_CARGO,

    count(SQ_CANDIDATO) as totalcandidatos,

    sum(masc) as totalmasc,
    sum(masc) / (1.0*count(SQ_CANDIDATO)) as txmasc,

    sum(fem) as totalfem,
    sum(fem) / (1.0*count(SQ_CANDIDATO)) as txfem,

    sum(cor_PRETA) as totalPRETA,
    sum(cor_PRETA) / (1.0* count(SQ_CANDIDATO)) as txPretos,

    sum(cor_PARDA) as totalPARDA,
    sum(cor_PARDA) / (1.0* count(SQ_CANDIDATO)) as txtPardos,

    sum(cor_BRANCA) as totalBRANCA,
    sum(cor_BRANCA) / (1.0* count(SQ_CANDIDATO)) as txBrancos,

    sum(cor_INDÍGENA) as totalINDÍGENA,
    sum(cor_INDÍGENA) / (1.0* count(SQ_CANDIDATO)) as txtIndigena,

    sum(cor_AMARELA) as totalAMARELA,
    sum(cor_AMARELA) / (1.0* count(SQ_CANDIDATO)) as txAmarelo,

    sum(cassado) as totalcassado,
    sum(cassado) / (1.0* count(SQ_CANDIDATO)) as txcassado,

    sum(EDUC_MEDIO) as totaEDUC_MEDIO,
    sum(EDUC_MEDIO) / (1.0* count(SQ_CANDIDATO)) as txEDUC_MEDIO,

    sum(EDUC_SUPERIOR) as totalEDUC_SUPERIOR,
    sum(EDUC_SUPERIOR) / (1.0* count(SQ_CANDIDATO)) as txEDUC_SUPERIOR,

    sum(EDUC_FUNDAMENTAL) as totalEDUC_FUNDAMENTAL,
    sum(EDUC_FUNDAMENTAL) / (1.0* count(SQ_CANDIDATO)) as txEDUC_FUNDAMENTAL,

    sum(SOLTEIRO) as totalSOLTEIRO,
    sum(SOLTEIRO) / (1.0* count(SQ_CANDIDATO)) as txSOLTEIRO,

    sum(CASADO) as totalCASADO,
    sum(CASADO) / (1.0* count(SQ_CANDIDATO)) as txCASADO,

    sum(DIVORCIADO) as totalDIVORCIADO,
    sum(DIVORCIADO) / (1.0* count(SQ_CANDIDATO)) as txDIVORCIADO,

    avg(idade) as med_idade

from tb_merge 
group by 1,2,3),

tb_taxas_tds_cargos as (select SG_UF,
    SG_PARTIDO,
    'TODOS' as DS_CARGO,

    count(SQ_CANDIDATO) as totalcandidatos,

    sum(masc) as totalmasc,
    sum(masc) / (1.0*count(SQ_CANDIDATO)) as txmasc,

    sum(fem) as totalfem,
    sum(fem) / (1.0*count(SQ_CANDIDATO)) as txfem,

    sum(cor_PRETA) as totalPRETA,
    sum(cor_PRETA) / (1.0* count(SQ_CANDIDATO)) as txPretos,

    sum(cor_PARDA) as totalPARDA,
    sum(cor_PARDA) / (1.0* count(SQ_CANDIDATO)) as txtPardos,

    sum(cor_BRANCA) as totalBRANCA,
    sum(cor_BRANCA) / (1.0* count(SQ_CANDIDATO)) as txBrancos,

    sum(cor_INDÍGENA) as totalINDÍGENA,
    sum(cor_INDÍGENA) / (1.0* count(SQ_CANDIDATO)) as txtIndigena,

    sum(cor_AMARELA) as totalAMARELA,
    sum(cor_AMARELA) / (1.0* count(SQ_CANDIDATO)) as txAmarelo,

    sum(cassado) as totalcassado,
    sum(cassado) / (1.0* count(SQ_CANDIDATO)) as txcassado,

    sum(EDUC_MEDIO) as totaEDUC_MEDIO,
    sum(EDUC_MEDIO) / (1.0* count(SQ_CANDIDATO)) as txEDUC_MEDIO,

    sum(EDUC_SUPERIOR) as totalEDUC_SUPERIOR,
    sum(EDUC_SUPERIOR) / (1.0* count(SQ_CANDIDATO)) as txEDUC_SUPERIOR,

    sum(EDUC_FUNDAMENTAL) as totalEDUC_FUNDAMENTAL,
    sum(EDUC_FUNDAMENTAL) / (1.0* count(SQ_CANDIDATO)) as txEDUC_FUNDAMENTAL,

    sum(SOLTEIRO) as totalSOLTEIRO,
    sum(SOLTEIRO) / (1.0* count(SQ_CANDIDATO)) as txSOLTEIRO,

    sum(CASADO) as totalCASADO,
    sum(CASADO) / (1.0* count(SQ_CANDIDATO)) as txCASADO,

    sum(DIVORCIADO) as totalDIVORCIADO,
    sum(DIVORCIADO) / (1.0* count(SQ_CANDIDATO)) as txDIVORCIADO,

    avg(idade) as med_idade

from tb_merge 
group by 1,2,3),

tb_taxas_tds_cargos_br as (select 'Brasil' as SG_UF,
    SG_PARTIDO,
    'TODOS' as DS_CARGO,

    count(SQ_CANDIDATO) as totalcandidatos,

    sum(masc) as totalmasc,
    sum(masc) / (1.0*count(SQ_CANDIDATO)) as txmasc,

    sum(fem) as totalfem,
    sum(fem) / (1.0*count(SQ_CANDIDATO)) as txfem,

    sum(cor_PRETA) as totalPRETA,
    sum(cor_PRETA) / (1.0* count(SQ_CANDIDATO)) as txPretos,

    sum(cor_PARDA) as totalPARDA,
    sum(cor_PARDA) / (1.0* count(SQ_CANDIDATO)) as txtPardos,

    sum(cor_BRANCA) as totalBRANCA,
    sum(cor_BRANCA) / (1.0* count(SQ_CANDIDATO)) as txBrancos,

    sum(cor_INDÍGENA) as totalINDÍGENA,
    sum(cor_INDÍGENA) / (1.0* count(SQ_CANDIDATO)) as txtIndigena,

    sum(cor_AMARELA) as totalAMARELA,
    sum(cor_AMARELA) / (1.0* count(SQ_CANDIDATO)) as txAmarelo,

    sum(cassado) as totalcassado,
    sum(cassado) / (1.0* count(SQ_CANDIDATO)) as txcassado,

    sum(EDUC_MEDIO) as totaEDUC_MEDIO,
    sum(EDUC_MEDIO) / (1.0* count(SQ_CANDIDATO)) as txEDUC_MEDIO,

    sum(EDUC_SUPERIOR) as totalEDUC_SUPERIOR,
    sum(EDUC_SUPERIOR) / (1.0* count(SQ_CANDIDATO)) as txEDUC_SUPERIOR,

    sum(EDUC_FUNDAMENTAL) as totalEDUC_FUNDAMENTAL,
    sum(EDUC_FUNDAMENTAL) / (1.0* count(SQ_CANDIDATO)) as txEDUC_FUNDAMENTAL,

    sum(SOLTEIRO) as totalSOLTEIRO,
    sum(SOLTEIRO) / (1.0* count(SQ_CANDIDATO)) as txSOLTEIRO,

    sum(CASADO) as totalCASADO,
    sum(CASADO) / (1.0* count(SQ_CANDIDATO)) as txCASADO,

    sum(DIVORCIADO) as totalDIVORCIADO,
    sum(DIVORCIADO) / (1.0* count(SQ_CANDIDATO)) as txDIVORCIADO,

    avg(idade) as med_idade

from tb_merge 
group by 1,2,3),

tb_taxas_geral as (

    select * from tb_taxas
    union ALL
    select * from tb_taxas_br
    union ALL
    select * from tb_taxas_tds_cargos
    union ALL
    select * from tb_taxas_tds_cargos_br

)

select * 
from tb_taxas_geral
order by 1,2,3