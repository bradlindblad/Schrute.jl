

using DataFrames
using DataFramesMeta
using Gadfly
using Schrute
using Statistics


df = Schrute.theOffice()

# what is the mean score per season?
@linq df |>
    by(:season, mean_score = mean(:imdb_rating)) |>
    select(:season, :mean_score) |>
    display

@linq df |>
    by(:season, mean_score = mean(:imdb_rating)) |>
    select(:season, :mean_score) |>
    plot(x=:season, y=:mean_score, Geom.line, Guide.xticks(ticks=collect(1:9)), Guide.title("Mean IMDB Score by Season"))


# who has the most lines in the series?
foo = by(df, :character,  nrow)[1:8,:]
sort!(foo, :x1, rev = true)
rename!(foo, Dict(:x1 => "Number of Lines"))

mytheme = Theme(bar_spacing=25pt);

plot(foo,
     x=:character,
     y=:"Number of Lines",
     Geom.bar,
     Guide.yticks(ticks=[2000,4000,6000,8000,10000,12000]),
     Guide.title("Lines by Character"),
     mytheme
)

# that's what she said?

twss = []
for line in df[:,:text]
    # println(line)
    try
        foo = occursin("what she said", line)
        # println(foo)
        push!(twss, string(foo))
    catch
        push!(twss, "false")
        continue
    end
end

df[:,:twss] = twss;

twss_df = @linq df |>
    where(:twss .== "true")
    by(:season, count(:twss))

twss_toplot =  by(twss_df, :character, nrow)
rename!(twss_toplot, Dict(:x1 => "Occurrences"))

plot(twss_toplot,
     x=:character,
     y=:Occurrences,
     Geom.bar,
     Guide.yticks(ticks=[5,10,15,20,25]),
     Guide.title("That's What She Said by Character"),
     mytheme
)


# writer vs. imdb score?
epi_hist = @linq df |>
    by(:season, mean_rating = mean(:imdb_rating))

set_default_plot_size(21cm, 8cm)
p = plot(df, xgroup=:season,  x=:episode, y=:imdb_rating,
    Geom.subplot_grid(Geom.line), Guide.title("IMDB Rating by Episode"))

draw(PNG("foo.png", 6inch, 4inch), p)

set_default_plot_size(9cm, 8cm)

plot(df,
    x=:season,
    y=:imdb_rating,
    Geom.boxplot,
    Guide.xticks(ticks=collect(1:9)),
    Guide.title("IMDB Rating Distribution by Season")
)


# what were those outliers in season 6 and 8?
@linq df |>
    by(:season, worst = minimum(:imdb_rating))

df_worst_a = @linq df |>
    # groupby([:episode_name, :season]) |>
    by([:episode_name, :season], score = mean(:imdb_rating))


df_worst_b = @linq df_worst_a |>
    groupby(:season) |>
    transform(min_sc = minimum(:score)) |>
    where(:min_sc .== :score) |>
    select(:season, :episode_name, :score)
