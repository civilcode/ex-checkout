defmodule ScannerFw.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/video.mjpg", to: ScannerFw.JPEGStreamer)

  match _ do
    send_resp(conn, 404, "Oops. Try /")
  end
end
