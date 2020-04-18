using DataFrames
using Schrute
using Test

@testset "Schrute.jl" begin

    @test DataFrames._ncol(theOffice()) == 12
    @test DataFrames._nrow(theOffice()) == 55130

end

