SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[p_DataDictionary]
(@table sysname = null)
as
begin

select	a.name [table],
		b.name [attribute],
		c.name [datatype],
		b.length,
		b.xprec as [precision],
		b.xscale as [scale],		
		b.isnullable [allow nulls?],
		case when d.name is null then 0 else 1 end [pkey?],
		case when e.parent_object_id is null then 0 else 1 end [fkey?],
		case when e.parent_object_id is null then '-' else g.name  end [ref table],
		case when h.value is null then '-' else h.value end [description]
from		sysobjects as a join syscolumns as b 
on		a.id = b.id
		join systypes as c 
on		b.xtype = c.xtype 
		left join	(select	so.id,
							sc.colid,
							sc.name 
					from    syscolumns sc join sysobjects so 
					on		so.id = sc.id
							join sysindexkeys si 
					on		so.id = si.id 
                    and		sc.colid = si.colid
					where	si.indid = 1) d 
on		a.id = d.id 
and		b.colid = d.colid
		left join sys.foreign_key_columns as e 
on		a.id = e.parent_object_id 
and		b.colid = e.parent_column_id    
		left join sys.objects as g 
on		e.referenced_object_id = g.object_id  
		left join sys.extended_properties as h 
on		a.id = h.major_id 
and		b.colid = h.minor_id
where	a.type = 'u' 
and		a.name = isnull(@table,a.name)
order by a.name

end

GO
