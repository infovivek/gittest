alter function dbo.CommaSeprate(@v float)
returns varchar(200)
as
begin
  declare @res varchar(50)
  declare @p1 varchar(40)
  declare @p2 varchar(10)

if(len(@v) > 3)
begin
  set @res = replace(convert (varchar(20), convert(money, @v), 3 ) , ',','')
  set @p1 = left(@res, charindex('.', @res)-1)
  set @p2 = substring(@res, charindex('.', @res), 10)

  set @res = right(@p1, 3) + @p2
  set @p1 = left(@p1, len(@p1)-3)

  while (@p1<>'')
  begin
    set @res = right(@p1, 2) + ',' + @res
    if (len(@p1) > 2)
      set @p1 = left(@p1, len(@p1)-2)
    else 
      set @p1= ''
  end

   return(@res)
  end
  else
  begin
  set @res=@v+'.00';
  end
   return(@res)
end


--Exec dbo.CommaSeprate @v=10