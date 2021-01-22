using Luxor

"""
    drawlogo(logo_width::Int)

Draw a `logo_width × logo_width`-sized square image logo for JuliaConstraints.
"""
function drawlogo(logo_width::Int)

    base_width = 1024
    s = logo_width/base_width

    origin() # Set origin to center of image
    scale(s) # Call to scale() must come after origin()

    ref_dist = 320

    ball_centers = [Point(-ref_dist,ref_dist), Point(0,-ref_dist), Point(ref_dist,ref_dist)]
    ball_radius = div(ref_dist,2)
    ball_colors = ["brown3", "forestgreen", "mediumorchid3"]

    link_small_thickness = div(ref_dist,16)*s # line thickness is not scaled http://juliagraphics.github.io/Luxor.jl/stable/transforms/#Scaling-of-lines
    link_large_length = div(ref_dist, 6)
    link_large_width = div(ref_dist, 8)
    link_num = 3 # number of large chains in each direction
    link_color = "royalblue"

    @layer begin # Draw triangle contour for a "small chain links" effect
        setcolor(link_color)
        setline(link_small_thickness)
        poly(ball_centers, :stroke, close=true)
    end
    
    @layer begin # Draw rounded rectangles for the "large chain links"
        setcolor(link_color)
        angles = (-atan(2), atan(2), 0)
        for i in 1:3
            pt1 = ball_centers[mod1(i, 3)]
            pt2 = ball_centers[mod1(i + 1, 3)]
            for j in 1:link_num
                link_large_shape = squircle(O, link_large_length, link_large_width, rt=0.5, vertices=true)
                link_large = poly(link_large_shape, :transparent)
                polyrotate!(link_large, angles[i])
                polymove!(link_large, O, between(pt1, pt2, j/(link_num+1)))
                poly(link_large, :fill)
            end
        end
    end

    @layer begin # Draw "chain" balls        
        for (ball_center, ball_color) in zip(ball_centers, ball_colors)
            setcolor(ball_color)
            circle(ball_center, ball_radius, :fill)
        end
    end    

    finish()
end

for logo_width in (1024, 512, 128, 32) # large, medium, small and favicon sizes
    Drawing(logo_width, logo_width, joinpath("logo_images", "jc-logo_"*string(logo_width)*"x"*string(logo_width)*".png"))
    drawlogo(logo_width)
end
