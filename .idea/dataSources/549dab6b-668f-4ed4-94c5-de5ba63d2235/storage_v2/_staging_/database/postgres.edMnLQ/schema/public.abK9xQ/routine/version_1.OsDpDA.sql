create function version_1(quantity integer, couponid integer, serialnumber character varying) returns integer
    language plpgsql
as
$$
DECLARE
    counter integer := 0;
    DECLARE    new_code varchar(50) := '';
    DECLARE    successItems integer  := 0;
begin

    while counter <  quantity loop
            new_code := CONCAT('serialNumber','_',cast(counter as varchar(10)));
            BEGIN
                counter := counter + 1;
                if not exists(
                        select id
                        from kukusha
                        where code = new_code
                          and id = couponId
                    ) then
                begin
                    insert into kukusha (code, id) values (new_code, couponid);
                    successItems := successItems  + 1;
                end;

                end if;
            end ;
        end loop;



    return successItems;

end
$$;

alter function version_1(integer, integer, varchar) owner to buka;

