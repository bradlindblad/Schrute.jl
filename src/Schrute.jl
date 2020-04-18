module Schrute

export theOffice


using CSV 
using DataFrames


const DATA = joinpath(@__DIR__, "theoffice.csv")



"""
theOffice()

Returns a Data Frame with 12 columns and 55130 rows.
"""
function theOffice()
    df = CSV.read(DATA)
    select!(df, Not(:Column1))
    return df
end


end # module
