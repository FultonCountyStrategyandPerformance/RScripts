###############
#
# SQL -> Socrata via R
#
# Date: 05/05/2017
#
###############
require(RODBC)
require(RSocrata)

dbhandle <- odbcDriverConnect('driver={SQL Server};server=PETERMOORE-PC\\SQLEXPRESS;database=fulton_county')
query <- "SELECT k.Quarter
    , k.Year
    , d.StartDate
    , p.Program
    , p.ProgramName
    , p.MeasureName
    , k.Value
    , p.Unit
    , i.Department
    , p.PriorityArea 
FROM PerformanceManagement_ProgramValues k
  JOIN PerformanceManagement_ProgramKPIs p
    ON p.MeasureID = k.MeasureID
  JOIN PerformanceManagement_Departments i
    ON i.DepartmentID = p.DepartmentID
  JOIN StartDates d
    ON k.Quarter = d.Quarter"

# Execute the Query
cat(paste("Executing: \n",query, sep=""))
r <- sqlQuery(dbhandle, query)
cat(paste("\n\nReturned: ",nrow(r)," rows"))

# Close database connection
odbcClose(dbhandle)

# Update Socrata Dataset
username = ""
password = ""
url = ""

# Write to socrata - uncomment when ready to replace the dataset
# write.socrata(r, url, update_mode = "REPLACE", email=username, password=password)


