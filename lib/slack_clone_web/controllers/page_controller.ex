defmodule SlackCloneWeb.PageController do
  use SlackCloneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
