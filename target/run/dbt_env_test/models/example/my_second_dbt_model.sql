

  create or replace view `pythonanalytics-164622`.`dbt_brgs`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `pythonanalytics-164622`.`dbt_brgs`.`my_first_dbt_model`
where id = 1;

