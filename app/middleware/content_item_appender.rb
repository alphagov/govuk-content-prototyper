# Middleware that **MAKES AN HTTP REQUEST** to the Content Store, and stores the result in the request env hash.
# Although this is surprising, this allows us to make routing decisions based on the content store item, at basically
# no overhead, since the content store item would have been fetched in the controller anyway
class ContentItemAppender
  def initialize(app)
    @app = app
  end

  def call(env)
    base_path = env['PATH_INFO']
    begin
      env['content_item'] = Services.content_store.content_item(base_path) if path_has_no_format?(base_path)
    rescue GdsApi::ContentStore::ItemNotFound
      # Ignore NotFound, and just don't set env['content_item']
    end
    @app.call(env)
  end

  # Check that the path does not have a dot (.) in it, which indicates that we shouldn't try to fetch a content store
  # item for it
  def path_has_no_format?(path)
    /\./ !~ path
  end
end
