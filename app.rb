require 'sinatra'

class App < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/' do
    @filename = params[:image_file][:filename]
    tempfile = params[:image_file][:tempfile]
    IO.write("tmp/#{@filename}", tempfile.read.b)

    [
      Thread.start {
        @filtered_result = `julia typical_colors.jl --filter tmp/#{@filename}`
      },
      Thread.start {
        @non_filtered_result = `julia typical_colors.jl tmp/#{@filename}`
      }
    ].each(&:join)

    haml :index
  end

  get '/img/:filename' do
    filename = "tmp/#{params[:filename]}"
    if File.exist? filename
      send_file filename, type: filetype(filename)
    else
      raise Sinatra::NotFound
    end
  end

  def filetype(filename)
    case filename
    when /\.jpg$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    end
  end
end
