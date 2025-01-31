select distinct DS_CARGO,
    count(DS_CARGO)
from tb_candidaturas
group by DS_CARGO