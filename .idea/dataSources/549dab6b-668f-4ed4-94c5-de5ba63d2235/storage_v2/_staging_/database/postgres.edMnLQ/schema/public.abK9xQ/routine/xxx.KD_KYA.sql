create function xxx(quantity integer, couponid integer, serialnumber character varying) returns integer
    language plpgsql
as
$$
begin


CREATE TEMPORARY TABLE temp_table(
                                     Code varchar(50),
                                     coupon_id int
);

WITH RECURSIVE t(n) AS (
    VALUES (1)
    UNION ALL
    SELECT n+1 FROM t WHERE n < 20
)




insert into temp_table(Code,coupon_id)
select CONCAT('asd','_',cast(t.n as varchar(10))),17 from t;

insert  into kukusha(id,code)
select distinct t.coupon_id,t.code from temp_table t
                                            left join kukusha tt on t.coupon_id = tt.id And t.Code = tt.code
where tt.id is null
RETURNING *;

drop table temp_table;

--select * from  kukusha
end
$$;

alter function xxx(integer, integer, varchar) owner to buka;

