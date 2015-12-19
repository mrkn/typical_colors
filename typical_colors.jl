using Images, Colors, FixedPointNumbers
using Clustering
using ArgParse

function filter_hsv_pixels(hsv_pixels::Array{HSV{Float32}, 2})
  filtered_pixels::Vector{HSV{Float32}} = []
  for i in 1:endof(hsv_pixels)
    x = hsv_pixels[i]
    if x.s > 0.5 && x.v > 0.5
      push!(filtered_pixels, x)
    end
  end
  return filtered_pixels
end

function hsv2vec(hsv_pixels::Vector{HSV{Float32}})
  pixel_vectors = Array(Float32, 3, length(hsv_pixels))
  for i in 1:endof(hsv_pixels)
    pixel = hsv_pixels[i]
    pixel_vectors[1, i] = pixel.h
    pixel_vectors[2, i] = pixel.s
    pixel_vectors[3, i] = pixel.v
  end
  return pixel_vectors
end

vec2hsv(x::Vector{Float32}) = HSV{Float32}(x[1], x[2], x[3])

function extract_typical_colors(filename, k; filter_pixels=false)
  image = imread(filename)

  hsv_image = convert(Image{HSV}, float32(image))

  if filter_pixels
    hsv_pixels = filter_hsv_pixels(hsv_image.data)
  else
    hsv_pixels = hsv_image.data
  end

  pixel_vectors = hsv2vec(hsv_pixels)
  result = kmeans(pixel_vectors, k)

  for i in 1:size(result.centers, 2)
    hsv = vec2hsv(result.centers[:, i])
    rgb = convert(RGB, hsv)
    rgb_vec = round(UInt8, 255*[rgb.r, rgb.g, rgb.b])
    @printf("[%d] rgb(#%02x%02x%02x), hsv(%.2f, %.3f, %.3f)\n", i, rgb_vec[1], rgb_vec[2], rgb_vec[3], hsv.h, hsv.s, hsv.v)
  end
end

function parse_cmdline(args)
  s = ArgParseSettings(
    description = "This program extract typical colors from the given images"
  )
  @add_arg_table s begin
    "-k"
      help = "the number of typical colors to be extracted"
      arg_type = Int
      default = 3
    "--filter"
      action = :store_true
      help = "filter pixels by S > 0.5 && V > 0.5 on HSV color space"
    "filenames"
      nargs = '*'
      help = "an image filenames"
      required = true
  end

  return parse_args(args, s)
end

if !isinteractive()
  function main(args)
    parsed_args = parse_cmdline(args)
    k = parsed_args["k"]
    for filename in parsed_args["filenames"]
      @printf("Typical colors of %s:\n", filename)
      extract_typical_colors(filename, k, filter_pixels=parsed_args["filter"])
      @printf("\n")
    end
  end

  main(ARGS)
end
