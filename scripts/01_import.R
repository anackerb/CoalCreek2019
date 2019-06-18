# This scripts imports data from OSMP SQL server

# load libraries ----------------------------------------------------------

require(RODBC)

options(stringsAsFactors = FALSE)

# open Monitoring db connection -------------------------------------------

conn_mon <- odbcDriverConnect("Driver=SQL Server; Server=OSMPGIS3; Database=Monitoring")

# import tables

tblProject <- sqlQuery(conn_mon,'SELECT * FROM dbo.tbl_Project WHERE Project_ID = 13')
tblSample <- sqlFetch(conn_mon, 'dbo.tbl_Sample')
tblEvent <- sqlFetch(conn_mon, 'dbo.tbl_Event')
tblVeg <- sqlFetch(conn_mon, 'tbl_CCVegData')

# close db connection

odbcClose(conn_mon)

# open Vegetation db connection -------------------------------------------

conn_veg <- odbcDriverConnect('Driver=SQL Server; Server=OSMPGIS3; Database=Vegetation')

# import tables

tblOSMPVeg <- sqlFetch(conn_veg, "dbo.ZtblOSMPVegetation")

# close db connection

odbcClose(conn_veg)