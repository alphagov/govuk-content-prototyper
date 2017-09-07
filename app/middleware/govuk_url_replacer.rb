require 'rack'

class GovukUrlReplacer
  def initialize(app)
     @app=app
  end

  # We want to replace links to www.gov.uk
  def call(env)
    res=@app.call(env)
    base_path = env['PATH_INFO']

    if path_has_no_format?(base_path)
      res[2][0].gsub! "https://www.gov.uk/", "/" #res[2][0] is the response body
      res[1]["Content-Length"] = res[2][0].length #res[1] contains the response headers
    end
    return res
  end

  def path_has_no_format?(path)
    /\./ !~ path
  end
end
