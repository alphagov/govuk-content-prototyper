require 'csv'

# This middleware logs routes visited to help in user lab analysis
class PathLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['PATH_INFO']
    if should_log?(path)
      File.open(Rails.root.join('log', 'paths.log'), 'a+') do |file|
        file.puts [Time.zone.now.iso8601, path].to_csv
      end
    end
    @app.call(env)
  end

  # Check that the path does not have a dot (.) in it, which indicates that we shouldn't try to fetch a content store
  # item for it
  def should_log?(path)
    /\./ !~ path
  end
end
