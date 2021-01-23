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

    triangle_side = 0.73*base_width
    triangle_height = triangle_side*√3/4

    ball_centers = [Point(-triangle_side/2,triangle_height), Point(0,-triangle_height), Point(triangle_side/2,triangle_height)]
    ball_radius = 0.18*triangle_side
    ball_colors = ["brown3", "forestgreen", "mediumorchid3"]

    link_num = 7 # number of chain links in each direction    
    link_small_width = triangle_side/48
    link_large_width = triangle_side/24
    link_thickness = 2*link_small_width*s # line thickness is not scaled http://juliagraphics.github.io/Luxor.jl/stable/transforms/#Scaling-of-lines
    link_length = triangle_side/link_num/2 + link_small_width/2
    
    
    link_color = "royalblue"

    @layer begin # Draw rounded rectangles for the "large chain links"
        setcolor(link_color)
        angles = (-π/3, π/3, 0)
        for i in 1:3
            pt1 = ball_centers[mod1(i, 3)]
            pt2 = ball_centers[mod1(i + 1, 3)]
            for j in 1:link_num+1
                if mod(j,2) == 1
                    link_shape = squircle(O, link_length, link_small_width, rt=0.5, vertices=true)
                    style = :fill
                else
                    link_shape = squircle(O, link_length, link_large_width, rt=0.5, vertices=true)
                    style = :stroke
                end
                link_large = poly(link_shape, :transparent)
                polyrotate!(link_large, angles[i])
                polymove!(link_large, O, between(pt1, pt2, j/(link_num+1)))
                setline(link_thickness)
                poly(link_large, style)
            end
        end
    end    

    @layer begin # Draw "chain" balls        
        for (ball_center, ball_color) in zip(ball_centers, ball_colors)
            setcolor(ball_color)
            circle(ball_center, ball_radius, :fill)
        end
    end    
end

for logo_width in (1024, 512, 128, 32) # large, medium, small and favicon sizes
    Drawing(logo_width, logo_width, joinpath("logo_images", "jc-logo_"*string(logo_width)*"x"*string(logo_width)*".png"))
    drawlogo(logo_width)
    finish()
end
