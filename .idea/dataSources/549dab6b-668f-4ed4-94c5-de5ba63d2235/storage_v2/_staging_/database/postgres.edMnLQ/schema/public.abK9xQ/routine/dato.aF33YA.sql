create function dato(quantity integer, couponid integer, serialnumber character varying) returns integer
    language plpgsql
as
$$
DECLARE
    counter integer := 0;
begin


    CREATE TEMPORARY TABLE temp_table(Code varchar(50), coupon_id int);
    CREATE TEMPORARY TABLE temp_table1(id int);

    WITH RECURSIVE t(n) AS (
        VALUES (1)
        UNION ALL
        SELECT n+1 FROM t WHERE n < quantity
    )
    insert into temp_table(Code,coupon_id)
    select CONCAT(serialnumber,'_',cast(t.n as varchar(10))),couponid from t;
    --სელექტი დაგენერირებულია მაგრამ ბაზაზე არ არის გაშვებული.
    WITH inserted AS (
        insert  into kukusha(id,code)
            select distinct t.coupon_id,t.code from temp_table t
                                                        left join kukusha tt on t.coupon_id = tt.id And t.Code = tt.code
            where tt.id is null
            RETURNING *)
    insert into temp_table1(id) select id from inserted;

     select Count(*) into counter from temp_table1;


    drop table temp_table;
    drop table temp_table1;
    return  counter ;
--select * from  kukusha
end
$$;